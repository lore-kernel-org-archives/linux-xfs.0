Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 051467F3F
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 16:54:56 -0500 (CDT)
Date: Fri, 3 Oct 2014 16:54:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 04/16] lib/utf8norm.c: reduce the size of utf8data[]
Message-ID: <20141003215455.GC1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Olaf Weber <olaf@sgi.com>

Remove the Hangul decompositions from the utf8data trie, and do
algorithmic decomposition to calculate them on the fly. To store
the decomposition the caller of utf8lookup()/utf8nlookup() must
provide a 12-byte buffer, which is used to synthesize a leaf with
the decomposition. Trie size is reduced from 245kB to 90kB.

This change also contains a number of robustness fixes to the
trie generator mkutf8data.c.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 include/linux/utf8norm.h |   4 +
 lib/utf8norm.c           | 190 ++++++++++++++++++---
 scripts/mkutf8data.c     | 421 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 492 insertions(+), 123 deletions(-)

diff --git a/include/linux/utf8norm.h b/include/linux/utf8norm.h
index 82f86c4..a6d8ce4 100644
--- a/include/linux/utf8norm.h
+++ b/include/linux/utf8norm.h
@@ -27,6 +27,9 @@
 /* An opaque type used to determine the normalization in use. */
 typedef const struct utf8data *utf8data_t;
 
+/* Needed in struct utf8cursor below. */
+#define UTF8HANGULLEAF	(12)
+
 /* Encoding a unicode version number as a single unsigned int. */
 #define UNICODE_MAJ_SHIFT		(16)
 #define UNICODE_MIN_SHIFT		(8)
@@ -95,6 +98,7 @@ struct utf8cursor {
 	unsigned int	slen;
 	short int	ccc;
 	short int	nccc;
+	unsigned char	hangul[UTF8HANGULLEAF];
 };
 
 /*
diff --git a/lib/utf8norm.c b/lib/utf8norm.c
index 0fa97d1..3ed9636 100644
--- a/lib/utf8norm.c
+++ b/lib/utf8norm.c
@@ -102,6 +102,38 @@ utf8clen(const char *s)
 }
 
 /*
+ * Decode a 3-byte UTF-8 sequence.
+ */
+static unsigned int
+utf8decode3(const char *str)
+{
+	unsigned int		uc;
+
+	uc = *str++ & 0x0F;
+	uc <<= 6;
+	uc |= *str++ & 0x3F;
+	uc <<= 6;
+	uc |= *str++ & 0x3F;
+
+	return uc;
+}
+
+/*
+ * Encode a 3-byte UTF-8 sequence.
+ */
+static int
+utf8encode3(char *str, unsigned int val)
+{
+	str[2] = (val & 0x3F) | 0x80;
+	val >>= 6;
+	str[1] = (val & 0x3F) | 0x80;
+	val >>= 6;
+	str[0] = val | 0xE0;
+
+	return 3;
+}
+
+/*
  * utf8trie_t
  *
  * A compact binary tree, used to decode UTF-8 characters.
@@ -162,7 +194,8 @@ typedef const unsigned char utf8trie_t;
  *          characters with the Default_Ignorable_Code_Point property.
  *          These do affect normalization, as they all have CCC 0.
  *
- * The decompositions in the trie have been fully expanded.
+ * The decompositions in the trie have been fully expanded, with the
+ * exception of Hangul syllables, which are decomposed algorithmically.
  *
  * Casefolding, if applicable, is also done using decompositions.
  *
@@ -182,6 +215,105 @@ typedef const unsigned char utf8leaf_t;
 #define STOPPER		(0)
 #define	DECOMPOSE	(255)
 
+/* Marker for hangul syllable decomposition. */
+#define HANGUL		((char)(255))
+/* Size of the synthesized leaf used for Hangul syllable decomposition. */
+#define UTF8HANGULLEAF	(12)
+
+/*
+ * Hangul decomposition (algorithm from Section 3.12 of Unicode 6.3.0)
+ *
+ * AC00;<Hangul Syllable, First>;Lo;0;L;;;;;N;;;;;
+ * D7A3;<Hangul Syllable, Last>;Lo;0;L;;;;;N;;;;;
+ *
+ * SBase = 0xAC00
+ * LBase = 0x1100
+ * VBase = 0x1161
+ * TBase = 0x11A7
+ * LCount = 19
+ * VCount = 21
+ * TCount = 28
+ * NCount = 588 (VCount * TCount)
+ * SCount = 11172 (LCount * NCount)
+ *
+ * Decomposition:
+ *   SIndex = s - SBase
+ *
+ * LV (Canonical/Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *
+ * LVT (Canonical)
+ *   LVIndex = (SIndex / TCount) * TCount
+ *   TIndex = (Sindex % TCount)
+ *   LVPart = SBase + LVIndex
+ *   TPart = TBase + TIndex
+ *
+ * LVT (Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   TIndex = (Sindex % TCount)
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *   if (TIndex == 0) {
+ *          d = <LPart, VPart>
+ *   } else {
+ *          TPart = TBase + TIndex
+ *          d = <LPart, TPart, VPart>
+ *   }
+ */
+
+/* Constants */
+#define SB	(0xAC00)
+#define LB	(0x1100)
+#define VB	(0x1161)
+#define TB	(0x11A7)
+#define LC	(19)
+#define VC	(21)
+#define TC	(28)
+#define NC	(VC * TC)
+#define SC	(LC * NC)
+
+/* Algorithmic decomposition of hangul syllable. */
+static utf8leaf_t *
+utf8hangul(const char *str, unsigned char *hangul)
+{
+	unsigned int	si;
+	unsigned int	li;
+	unsigned int	vi;
+	unsigned int	ti;
+	unsigned char	*h;
+
+	/* Calculate the SI, LI, VI, and TI values. */
+	si = utf8decode3(str) - SB;
+	li = si / NC;
+	vi = (si % NC) / TC;
+	ti = si % TC;
+
+	/* Fill in base of leaf. */
+	h = hangul;
+	LEAF_GEN(h) = 2;
+	LEAF_CCC(h) = DECOMPOSE;
+	h += 2;
+
+	/* Add LPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode3((char*)h, li + LB);
+
+	/* Add VPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode3((char*)h, vi + VB);
+
+	/* Add TPart if required, also a 3-byte UTF-8 sequence. */
+	if (ti)
+		h += utf8encode3((char*)h, ti + TB);
+
+	/* Terminate string. */
+	h[0] = '\0';
+
+	return hangul;
+}
+
 /*
  * Use trie to scan s, touching at most len bytes.
  * Returns the leaf if one exists, NULL otherwise.
@@ -191,7 +323,7 @@ typedef const unsigned char utf8leaf_t;
  * shorthand for this will be "is valid UTF-8 unicode".
  */
 static utf8leaf_t *
-utf8nlookup(utf8data_t data, const char *s, size_t len)
+utf8nlookup(utf8data_t data, unsigned char *hangul, const char *s, size_t len)
 {
 	utf8trie_t	*trie = utf8data + data->offset;
 	int		offlen;
@@ -229,8 +361,7 @@ utf8nlookup(utf8data_t data, const char *s, size_t len)
 				trie++;
 			} else {
 				/* No right node. */
-				node = 0;
-				trie = NULL;
+				return NULL;
 			}
 		} else {
 			/* Left leg */
@@ -240,8 +371,7 @@ utf8nlookup(utf8data_t data, const char *s, size_t len)
 				trie += offlen + 1;
 			} else if (*trie & RIGHTPATH) {
 				/* No left node. */
-				node = 0;
-				trie = NULL;
+				return NULL;
 			} else {
 				/* Left node after this node */
 				node = (*trie & TRIENODE);
@@ -249,6 +379,14 @@ utf8nlookup(utf8data_t data, const char *s, size_t len)
 			}
 		}
 	}
+	/*
+	 * Hangul decomposition is done algorithmically. These are the
+	 * codepoints >= 0xAC00 and <= 0xD7A3. Their UTF-8 encoding is
+	 * always 3 bytes long, so s has been advanced twice, and the
+	 * start of the sequence is at s-2.
+	 */
+	if (LEAF_CCC(trie) == DECOMPOSE && LEAF_STR(trie)[0] == HANGUL)
+		trie = utf8hangul(s - 2, hangul);
 	return trie;
 }
 
@@ -259,9 +397,9 @@ utf8nlookup(utf8data_t data, const char *s, size_t len)
  * Forwards to utf8nlookup().
  */
 static utf8leaf_t *
-utf8lookup(utf8data_t data, const char *s)
+utf8lookup(utf8data_t data, unsigned char *hangul, const char *s)
 {
-	return utf8nlookup(data, s, (size_t)-1);
+	return utf8nlookup(data, hangul, s, (size_t)-1);
 }
 
 /*
@@ -273,13 +411,15 @@ int
 utf8agemax(utf8data_t data, const char *s)
 {
 	utf8leaf_t	*leaf;
-	int		age = 0;
+	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
+	age = 0;
 	while (*s) {
-		if (!(leaf = utf8lookup(data, s)))
+		if (!(leaf = utf8lookup(data, hangul, s)))
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
 		if (leaf_age <= data->maxage && leaf_age > age)
@@ -301,12 +441,13 @@ utf8agemin(utf8data_t data, const char *s)
 	utf8leaf_t	*leaf;
 	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	age = data->maxage;
 	while (*s) {
-		if (!(leaf = utf8lookup(data, s)))
+		if (!(leaf = utf8lookup(data, hangul, s)))
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
 		if (leaf_age <= data->maxage && leaf_age < age)
@@ -325,13 +466,15 @@ int
 utf8nagemax(utf8data_t data, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
-	int		age = 0;
+	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
+	age = 0;
         while (len && *s) {
-		if (!(leaf = utf8nlookup(data, s, len)))
+		if (!(leaf = utf8nlookup(data, hangul, s, len)))
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
 		if (leaf_age <= data->maxage && leaf_age > age)
@@ -353,12 +496,13 @@ utf8nagemin(utf8data_t data, const char *s, size_t len)
 	utf8leaf_t	*leaf;
 	int		leaf_age;
 	int		age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	age = data->maxage;
 	while (len && *s) {
-		if (!(leaf = utf8nlookup(data, s, len)))
+		if (!(leaf = utf8nlookup(data, hangul, s, len)))
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
 		if (leaf_age <= data->maxage && leaf_age < age)
@@ -381,11 +525,12 @@ utf8len(utf8data_t data, const char *s)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	while (*s) {
-		if (!(leaf = utf8lookup(data, s)))
+		if (!(leaf = utf8lookup(data, hangul, s)))
 			return -1;
 		if (utf8agetab[LEAF_GEN(leaf)] > data->maxage)
 			ret += utf8clen(s);
@@ -408,11 +553,12 @@ utf8nlen(utf8data_t data, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	while (len && *s) {
-		if (!(leaf = utf8nlookup(data, s, len)))
+		if (!(leaf = utf8nlookup(data, hangul, s, len)))
 			return -1;
 		if (utf8agetab[LEAF_GEN(leaf)] > data->maxage)
 			ret += utf8clen(s);
@@ -542,10 +688,12 @@ utf8byte(struct utf8cursor *u8c)
 		}
 
 		/* Look up the data for the current character. */
-		if (u8c->p)
-			leaf = utf8lookup(u8c->data, u8c->s);
-		else
-			leaf = utf8nlookup(u8c->data, u8c->s, u8c->len);
+		if (u8c->p) {
+			leaf = utf8lookup(u8c->data, u8c->hangul, u8c->s);
+		} else {
+			leaf = utf8nlookup(u8c->data, u8c->hangul,
+					   u8c->s, u8c->len);
+		}
 
 		/* No leaf found implies that the input is a binary blob. */
 		if (!leaf)
@@ -565,7 +713,7 @@ utf8byte(struct utf8cursor *u8c)
 				ccc = STOPPER;
 				goto ccc_mismatch;
 			}
-			leaf = utf8lookup(u8c->data, u8c->s);
+			leaf = utf8lookup(u8c->data, u8c->hangul, u8c->s);
 			ccc = LEAF_CCC(leaf);
 		}
 
diff --git a/scripts/mkutf8data.c b/scripts/mkutf8data.c
index 1d6ec02..7c7756f 100644
--- a/scripts/mkutf8data.c
+++ b/scripts/mkutf8data.c
@@ -179,11 +179,15 @@ typedef unsigned char utf8leaf_t;
 #define MINCCC		(0)
 #define MAXCCC		(254)
 #define STOPPER		(0)
-#define	DECOMPOSE	(255)
+#define DECOMPOSE	(255)
+#define HANGUL		((char)(255))
+
+#define UTF8HANGULLEAF	(12)
 
 struct tree;
-static utf8leaf_t *utf8nlookup(struct tree *, const char *, size_t);
-static utf8leaf_t *utf8lookup(struct tree *, const char *);
+static utf8leaf_t *utf8nlookup(struct tree *, unsigned char *,
+			       const char *, size_t);
+static utf8leaf_t *utf8lookup(struct tree *, unsigned char *, const char *);
 
 unsigned char *utf8data;
 size_t utf8data_size;
@@ -254,52 +258,52 @@ utf8trie_t *nfkdicf;
 #define UTF8_V_SHIFT    6
 
 static int
-utf8key(unsigned int key, char keyval[])
-{
-	int keylen;
-
-	if (key < 0x80) {
-		keyval[0] = key;
-		keylen = 1;
-	} else if (key < 0x800) {
-		keyval[1] = key & UTF8_V_MASK;
-		keyval[1] |= UTF8_N_BITS;
-		key >>= UTF8_V_SHIFT;
-		keyval[0] = key;
-		keyval[0] |= UTF8_2_BITS;
-		keylen = 2;
-	} else if (key < 0x10000) {
-		keyval[2] = key & UTF8_V_MASK;
-		keyval[2] |= UTF8_N_BITS;
-		key >>= UTF8_V_SHIFT;
-		keyval[1] = key & UTF8_V_MASK;
-		keyval[1] |= UTF8_N_BITS;
-		key >>= UTF8_V_SHIFT;
-		keyval[0] = key;
-		keyval[0] |= UTF8_3_BITS;
-		keylen = 3;
-	} else if (key < 0x110000) {
-		keyval[3] = key & UTF8_V_MASK;
-		keyval[3] |= UTF8_N_BITS;
-		key >>= UTF8_V_SHIFT;
-		keyval[2] = key & UTF8_V_MASK;
-		keyval[2] |= UTF8_N_BITS;
-		key >>= UTF8_V_SHIFT;
-		keyval[1] = key & UTF8_V_MASK;
-		keyval[1] |= UTF8_N_BITS;
-		key >>= UTF8_V_SHIFT;
-		keyval[0] = key;
-		keyval[0] |= UTF8_4_BITS;
-		keylen = 4;
+utf8encode(char *str, unsigned int val)
+{
+	int len;
+
+	if (val < 0x80) {
+		str[0] = val;
+		len = 1;
+	} else if (val < 0x800) {
+		str[1] = val & UTF8_V_MASK;
+		str[1] |= UTF8_N_BITS;
+		val >>= UTF8_V_SHIFT;
+		str[0] = val;
+		str[0] |= UTF8_2_BITS;
+		len = 2;
+	} else if (val < 0x10000) {
+		str[2] = val & UTF8_V_MASK;
+		str[2] |= UTF8_N_BITS;
+		val >>= UTF8_V_SHIFT;
+		str[1] = val & UTF8_V_MASK;
+		str[1] |= UTF8_N_BITS;
+		val >>= UTF8_V_SHIFT;
+		str[0] = val;
+		str[0] |= UTF8_3_BITS;
+		len = 3;
+	} else if (val < 0x110000) {
+		str[3] = val & UTF8_V_MASK;
+		str[3] |= UTF8_N_BITS;
+		val >>= UTF8_V_SHIFT;
+		str[2] = val & UTF8_V_MASK;
+		str[2] |= UTF8_N_BITS;
+		val >>= UTF8_V_SHIFT;
+		str[1] = val & UTF8_V_MASK;
+		str[1] |= UTF8_N_BITS;
+		val >>= UTF8_V_SHIFT;
+		str[0] = val;
+		str[0] |= UTF8_4_BITS;
+		len = 4;
 	} else {
-		printf("%#x: illegal key\n", key);
-		keylen = 0;
+		printf("%#x: illegal val\n", val);
+		len = 0;
 	}
-	return keylen;
+	return len;
 }
 
 static unsigned int
-utf8code(const char *str)
+utf8decode(const char *str)
 {
 	const unsigned char *s = (const unsigned char*)str;
 	unsigned int unichar = 0;
@@ -334,6 +338,8 @@ utf32valid(unsigned int unichar)
 	return unichar < 0x110000;
 }
 
+#define HANGUL_SYLLABLE(U)	((U) >= 0xAC00 && (U) <= 0xD7A3)
+
 #define NODE 1
 #define LEAF 0
 
@@ -937,7 +943,7 @@ done:
 
 /*
  * Compute the index of each node and leaf, which is the offset in the
- * emitted trie.  These value must be pre-computed because relative
+ * emitted trie.  These values must be pre-computed because relative
  * offsets between nodes are used to navigate the tree.
  */
 static int
@@ -958,7 +964,7 @@ index_nodes(struct tree *tree, int index)
 	count = 0;
 
 	if (verbose > 0)
-		printf("Indexing %s_%x: %d", tree->type, tree->maxage, index);
+		printf("Indexing %s_%x: %d\n", tree->type, tree->maxage, index);
 	if (tree->childnode == LEAF) {
 		index += tree->leaf_size(tree->root);
 		goto done;
@@ -1022,6 +1028,26 @@ done:
 }
 
 /*
+ * Mark the nodes in a subtree, helper for size_nodes().
+ */
+static int
+mark_subtree(struct node *node)
+{
+	int changed;
+
+	if (!node || node->mark)
+		return 0;
+	node->mark = 1;
+	node->index = node->parent->index;
+	changed = 1;
+	if (node->leftnode == NODE)
+		changed += mark_subtree(node->left);
+	if (node->rightnode == NODE)
+		changed += mark_subtree(node->right);
+	return changed;
+}
+
+/*
  * Compute the size of nodes and leaves. We start by assuming that
  * each node needs to store a three-byte offset. The indexes of the
  * nodes are calculated based on that, and then this function is
@@ -1040,6 +1066,7 @@ size_nodes(struct tree *tree)
 	unsigned int bitmask;
 	unsigned int pathbits;
 	unsigned int pathmask;
+	unsigned int nbit;
 	int changed;
 	int offset;
 	int size;
@@ -1050,7 +1077,7 @@ size_nodes(struct tree *tree)
 	size = 0;
 
 	if (verbose > 0)
-		printf("Sizing %s_%x", tree->type, tree->maxage);
+		printf("Sizing %s_%x\n", tree->type, tree->maxage);
 	if (tree->childnode == LEAF)
 		goto done;
 
@@ -1067,22 +1094,40 @@ size_nodes(struct tree *tree)
 			size = 1;
 		} else {
 			if (node->rightnode == NODE) {
+				/*
+				 * If the right node is not marked,
+				 * look for a corresponding node in
+				 * the next tree.  Such a node need
+				 * not exist.
+				 */
 				right = node->right;
 				next = tree->next;
 				while (!right->mark) {
 					assert(next);
 					n = next->root;
 					while (n->bitnum != node->bitnum) {
-						if (pathbits & (1<<n->bitnum))
+						nbit = 1 << n->bitnum;
+						if (!(pathmask & nbit))
+							break;
+						if (pathbits & nbit) {
+							if (n->rightnode==LEAF)
+								break;
 							n = n->right;
-						else
+						} else {
+							if (n->leftnode==LEAF)
+								break;
 							n = n->left;
+						}
 					}
+					if (n->bitnum != node->bitnum)
+						break;
 					n = n->right;
-					assert(right->bitnum == n->bitnum);
 					right = n;
 					next = next->next;
 				}
+				/* Make sure the right node is marked. */
+				if (!right->mark)
+					changed += mark_subtree(right);
 				offset = right->index - node->index;
 			} else {
 				offset = *tree->leaf_index(tree, node->right);
@@ -1158,8 +1203,15 @@ emit(struct tree *tree, unsigned char *data)
 	int offset;
 	int index;
 	int indent;
+	int size;
+	int bytes;
+	int leaves;
+	int nodes[4];
 	unsigned char byte;
 
+	nodes[0] = nodes[1] = nodes[2] = nodes[3] = 0;
+	leaves = 0;
+	bytes = 0;
 	index = tree->index;
 	data += index;
 	indent = 1;
@@ -1168,7 +1220,10 @@ emit(struct tree *tree, unsigned char *data)
 	if (tree->childnode == LEAF) {
 		assert(tree->root);
 		tree->leaf_emit(tree->root, data);
-		return;
+		size = tree->leaf_size(tree->root);
+		index += size;
+		leaves++;
+		goto done;
 	}
 
 	assert(tree->childnode == NODE);
@@ -1195,6 +1250,7 @@ emit(struct tree *tree, unsigned char *data)
 				offlen = 2;
 			else
 				offlen = 3;
+			nodes[offlen]++;
 			offset = node->offset;
 			byte |= offlen << OFFLEN_SHIFT;
 			*data++ = byte;
@@ -1207,12 +1263,14 @@ emit(struct tree *tree, unsigned char *data)
 		} else if (node->left) {
 			if (node->leftnode == NODE)
 				byte |= TRIENODE;
+			nodes[0]++;
 			*data++ = byte;
 			index++;
 		} else if (node->right) {
 			byte |= RIGHTNODE;
 			if (node->rightnode == NODE)
 				byte |= TRIENODE;
+			nodes[0]++;
 			*data++ = byte;
 			index++;
 		} else {
@@ -1227,7 +1285,10 @@ skip:
 					assert(node->left);
 					data = tree->leaf_emit(node->left,
 							       data);
-					index += tree->leaf_size(node->left);
+					size = tree->leaf_size(node->left);
+					index += size;
+					bytes += size;
+					leaves++;
 				} else if (node->left) {
 					assert(node->leftnode == NODE);
 					indent += 1;
@@ -1241,7 +1302,10 @@ skip:
 					assert(node->right);
 					data = tree->leaf_emit(node->right,
 							       data);
-					index += tree->leaf_size(node->right);
+					size = tree->leaf_size(node->right);
+					index += size;
+					bytes += size;
+					leaves++;
 				} else if (node->right) {
 					assert(node->rightnode==NODE);
 					indent += 1;
@@ -1255,6 +1319,15 @@ skip:
 			indent -= 1;
 		}
 	}
+done:
+	if (verbose > 0) {
+		printf("Emitted %d (%d) leaves",
+			leaves, bytes);
+		printf(" %d (%d+%d+%d+%d) nodes",
+			nodes[0] + nodes[1] + nodes[2] + nodes[3],
+			nodes[0], nodes[1], nodes[2], nodes[3]);
+		printf(" %d total\n", index - tree->index);
+	}
 }
 
 /* ------------------------------------------------------------------ */
@@ -1360,7 +1433,9 @@ nfkdi_print(void *l, int indent)
 
 	printf("%*sleaf @ %p code %X ccc %d gen %d", indent, "", leaf,
 		leaf->code, leaf->ccc, leaf->gen);
-	if (leaf->utf8nfkdi)
+	if (leaf->utf8nfkdi && leaf->utf8nfkdi[0] == HANGUL)
+		printf(" nfkdi \"%s\"", "HANGUL SYLLABLE");
+	else if (leaf->utf8nfkdi)
 		printf(" nfkdi \"%s\"", (const char*)leaf->utf8nfkdi);
 	printf("\n");
 }
@@ -1374,6 +1449,8 @@ nfkdicf_print(void *l, int indent)
 		leaf->code, leaf->ccc, leaf->gen);
 	if (leaf->utf8nfkdicf)
 		printf(" nfkdicf \"%s\"", (const char*)leaf->utf8nfkdicf);
+	else if (leaf->utf8nfkdi && leaf->utf8nfkdi[0] == HANGUL)
+		printf(" nfkdi \"%s\"", "HANGUL SYLLABLE");
 	else if (leaf->utf8nfkdi)
 		printf(" nfkdi \"%s\"", (const char*)leaf->utf8nfkdi);
 	printf("\n");
@@ -1409,7 +1486,9 @@ nfkdi_size(void *l)
 	struct unicode_data *leaf = l;
 
 	int size = 2;
-	if (leaf->utf8nfkdi)
+	if (HANGUL_SYLLABLE(leaf->code))
+		size += 1;
+	else if (leaf->utf8nfkdi)
 		size += strlen(leaf->utf8nfkdi) + 1;
 	return size;
 }
@@ -1420,7 +1499,9 @@ nfkdicf_size(void *l)
 	struct unicode_data *leaf = l;
 
 	int size = 2;
-	if (leaf->utf8nfkdicf)
+	if (HANGUL_SYLLABLE(leaf->code))
+		size += 1;
+	else if (leaf->utf8nfkdicf)
 		size += strlen(leaf->utf8nfkdicf) + 1;
 	else if (leaf->utf8nfkdi)
 		size += strlen(leaf->utf8nfkdi) + 1;
@@ -1450,7 +1531,10 @@ nfkdi_emit(void *l, unsigned char *data)
 	unsigned char *s;
 
 	*data++ = leaf->gen;
-	if (leaf->utf8nfkdi) {
+	if (HANGUL_SYLLABLE(leaf->code)) {
+		*data++ = DECOMPOSE;
+		*data++ = HANGUL;
+	} else if (leaf->utf8nfkdi) {
 		*data++ = DECOMPOSE;
 		s = (unsigned char*)leaf->utf8nfkdi;
 		while ((*data++ = *s++) != 0)
@@ -1468,7 +1552,10 @@ nfkdicf_emit(void *l, unsigned char *data)
 	unsigned char *s;
 
 	*data++ = leaf->gen;
-	if (leaf->utf8nfkdicf) {
+	if (HANGUL_SYLLABLE(leaf->code)) {
+		*data++ = DECOMPOSE;
+		*data++ = HANGUL;
+	} else if (leaf->utf8nfkdicf) {
 		*data++ = DECOMPOSE;
 		s = (unsigned char*)leaf->utf8nfkdicf;
 		while ((*data++ = *s++) != 0)
@@ -1492,22 +1579,27 @@ utf8_create(struct unicode_data *data)
 	unsigned int *um;
 	int i;
 
+	if (data->utf8nfkdi) {
+		assert(data->utf8nfkdi[0] == HANGUL);
+		return;
+	}
+
 	u = utf;
 	um = data->utf32nfkdi;
 	if (um) {
 		for (i = 0; um[i]; i++)
-			u += utf8key(um[i], u);
+			u += utf8encode(u, um[i]);
 		*u = '\0';
-		data->utf8nfkdi = strdup((char*)utf);
+		data->utf8nfkdi = strdup(utf);
 	}
 	u = utf;
 	um = data->utf32nfkdicf;
 	if (um) {
 		for (i = 0; um[i]; i++)
-			u += utf8key(um[i], u);
+			u += utf8encode(u, um[i]);
 		*u = '\0';
-		if (!data->utf8nfkdi || strcmp(data->utf8nfkdi, (char*)utf))
-			data->utf8nfkdicf = strdup((char*)utf);
+		if (!data->utf8nfkdi || strcmp(data->utf8nfkdi, utf))
+			data->utf8nfkdicf = strdup(utf);
 	}
 }
 
@@ -1627,7 +1719,7 @@ trees_populate(void)
 		for (unichar = 0; unichar != 0x110000; unichar++) {
 			if (unicode_data[unichar].gen < 0)
 				continue;
-			keylen = utf8key(unichar, keyval);
+			keylen = utf8encode(keyval, unichar);
 			data = corrections_lookup(&unicode_data[unichar]);
 			if (data->correction <= trees[i].maxage)
 				data = &unicode_data[unichar];
@@ -1682,6 +1774,7 @@ verify(struct tree *tree)
 	utf8leaf_t	*leaf;
 	unsigned int	unichar;
 	char		key[4];
+	unsigned char	hangul[UTF8HANGULLEAF];
 	int		report;
 	int		nocf;
 
@@ -1694,8 +1787,8 @@ verify(struct tree *tree)
 		data = corrections_lookup(&unicode_data[unichar]);
 		if (data->correction <= tree->maxage)
 			data = &unicode_data[unichar];
-		utf8key(unichar, key);
-		leaf = utf8lookup(tree, key);
+		utf8encode(key, unichar);
+		leaf = utf8lookup(tree, hangul, key);
 		if (!leaf) {
 			if (data->gen != -1)
 				report++;
@@ -1709,7 +1802,10 @@ verify(struct tree *tree)
 			if (data->gen != LEAF_GEN(leaf))
 				report++;
 			if (LEAF_CCC(leaf) == DECOMPOSE) {
-				if (nocf) {
+				if (HANGUL_SYLLABLE(data->code)) {
+					if (data->utf8nfkdi[0] != HANGUL)
+						report++;
+				} else if (nocf) {
 					if (!data->utf8nfkdi) {
 						report++;
 					} else if (strcmp(data->utf8nfkdi,
@@ -1725,7 +1821,7 @@ verify(struct tree *tree)
 							   LEAF_STR(leaf)))
 							report++;
 					} else if (strcmp(data->utf8nfkdi,
-							  LEAF_STR(leaf))) {
+							LEAF_STR(leaf))) {
 						report++;
 					}
 				}
@@ -1735,13 +1831,13 @@ verify(struct tree *tree)
 		}
 		if (report) {
 			printf("%X code %X gen %d ccc %d"
-				" nfdki -> \"%s\"",
+				" nfkdi -> \"%s\"",
 				unichar, data->code, data->gen,
 				data->ccc,
 				data->utf8nfkdi);
 			if (leaf) {
-				printf(" age %d ccc %d"
-					" nfdki -> \"%s\"\n",
+				printf(" gen %d ccc %d"
+					" nfkdi -> \"%s\"",
 					LEAF_GEN(leaf),
 					LEAF_CCC(leaf),
 					LEAF_CCC(leaf) == DECOMPOSE ?
@@ -2330,21 +2426,21 @@ corrections_init(void)
  *
  * LVT (Canonical)
  *   LVIndex = (SIndex / TCount) * TCount
- *   TIndex = (Sindex % TCount
- *   LVPart = LBase + LVIndex
+ *   TIndex = (Sindex % TCount)
+ *   LVPart = SBase + LVIndex
  *   TPart = TBase + TIndex
  *
  * LVT (Full)
  *   LIndex = SIndex / NCount
  *   VIndex = (Sindex % NCount) / TCount
- *   TIndex = (Sindex % TCount
+ *   TIndex = (Sindex % TCount)
  *   LPart = LBase + LIndex
  *   VPart = VBase + VIndex
  *   if (TIndex == 0) {
  *          d = <LPart, VPart>
  *   } else {
  *          TPart = TBase + TIndex
- *          d = <LPart, TPart, VPart>
+ *          d = <LPart, VPart, TPart>
  *   }
  *
  */
@@ -2394,9 +2490,17 @@ hangul_decompose(void)
 		memcpy(um, mapping, i * sizeof(unsigned int));
 		unicode_data[unichar].utf32nfkdicf = um;
 
+		/*
+		 * Add a cookie as a reminder that the hangul syllable
+		 * decompositions must not be stored in the generated
+		 * trie.
+		 */
+		unicode_data[unichar].utf8nfkdi = malloc(2);
+		unicode_data[unichar].utf8nfkdi[0] = HANGUL;
+		unicode_data[unichar].utf8nfkdi[1] = '\0';
+
 		if (verbose > 1)
 			print_utf32nfkdi(unichar);
-
 		count++;
 	}
 	if (verbose > 0)
@@ -2522,6 +2626,100 @@ int utf8ncursor(struct utf8cursor *, struct tree *, const char *, size_t);
 int utf8byte(struct utf8cursor *);
 
 /*
+ * Hangul decomposition (algorithm from Section 3.12 of Unicode 6.3.0)
+ *
+ * AC00;<Hangul Syllable, First>;Lo;0;L;;;;;N;;;;;
+ * D7A3;<Hangul Syllable, Last>;Lo;0;L;;;;;N;;;;;
+ *
+ * SBase = 0xAC00
+ * LBase = 0x1100
+ * VBase = 0x1161
+ * TBase = 0x11A7
+ * LCount = 19
+ * VCount = 21
+ * TCount = 28
+ * NCount = 588 (VCount * TCount)
+ * SCount = 11172 (LCount * NCount)
+ *
+ * Decomposition:
+ *   SIndex = s - SBase
+ *
+ * LV (Canonical/Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *
+ * LVT (Canonical)
+ *   LVIndex = (SIndex / TCount) * TCount
+ *   TIndex = (Sindex % TCount)
+ *   LVPart = SBase + LVIndex
+ *   TPart = TBase + TIndex
+ *
+ * LVT (Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   TIndex = (Sindex % TCount)
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *   if (TIndex == 0) {
+ *          d = <LPart, VPart>
+ *   } else {
+ *          TPart = TBase + TIndex
+ *          d = <LPart, VPart, TPart>
+ *   }
+ */
+
+/* Constants */
+#define SB	(0xAC00)
+#define LB	(0x1100)
+#define VB	(0x1161)
+#define TB	(0x11A7)
+#define LC	(19)
+#define VC	(21)
+#define TC	(28)
+#define NC	(VC * TC)
+#define SC	(LC * NC)
+
+/* Algorithmic decomposition of hangul syllable. */
+static utf8leaf_t *
+utf8hangul(const char *str, unsigned char *hangul)
+{
+	unsigned int	si;
+	unsigned int	li;
+	unsigned int	vi;
+	unsigned int	ti;
+	unsigned char	*h;
+
+	/* Calculate the SI, LI, VI, and TI values. */
+	si = utf8decode(str) - SB;
+	li = si / NC;
+	vi = (si % NC) / TC;
+	ti = si % TC;
+
+	/* Fill in base of leaf. */
+	h = hangul;
+	LEAF_GEN(h) = 2;
+	LEAF_CCC(h) = DECOMPOSE;
+	h += 2;
+
+	/* Add LPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode((char *)h, li + LB);
+
+	/* Add VPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode((char *)h, vi + VB);
+
+	/* Add TPart if required, also a 3-byte UTF-8 sequence. */
+	if (ti)
+		h += utf8encode((char *)h, ti + TB);
+
+	/* Terminate string. */
+	h[0] = '\0';
+
+	return hangul;
+}
+
+/*
  * Use trie to scan s, touching at most len bytes.
  * Returns the leaf if one exists, NULL otherwise.
  *
@@ -2530,7 +2728,7 @@ int utf8byte(struct utf8cursor *);
  * shorthand for this will be "is valid UTF-8 unicode".
  */
 static utf8leaf_t *
-utf8nlookup(struct tree *tree, const char *s, size_t len)
+utf8nlookup(struct tree *tree, unsigned char *hangul, const char *s, size_t len)
 {
 	utf8trie_t	*trie = utf8data + tree->index;
 	int		offlen;
@@ -2568,8 +2766,7 @@ utf8nlookup(struct tree *tree, const char *s, size_t len)
 				trie++;
 			} else {
 				/* No right node. */
-				node = 0;
-				trie = NULL;
+				return NULL;
 			}
 		} else {
 			/* Left leg */
@@ -2579,8 +2776,7 @@ utf8nlookup(struct tree *tree, const char *s, size_t len)
 				trie += offlen + 1;
 			} else if (*trie & RIGHTPATH) {
 				/* No left node. */
-				node = 0;
-				trie = NULL;
+				return NULL;
 			} else {
 				/* Left node after this node */
 				node = (*trie & TRIENODE);
@@ -2588,6 +2784,14 @@ utf8nlookup(struct tree *tree, const char *s, size_t len)
 			}
 		}
 	}
+	/*
+	 * Hangul decomposition is done algorithmically. These are the
+	 * codepoints >= 0xAC00 and <= 0xD7A3. Their UTF-8 encoding is
+	 * always 3 bytes long, so s has been advanced twice, and the
+	 * start of the sequence is at s-2.
+	 */
+	if (LEAF_CCC(trie) == DECOMPOSE && LEAF_STR(trie)[0] == HANGUL)
+		trie = utf8hangul(s - 2, hangul);
 	return trie;
 }
 
@@ -2598,9 +2802,9 @@ utf8nlookup(struct tree *tree, const char *s, size_t len)
  * Forwards to trie_nlookup().
  */
 static utf8leaf_t *
-utf8lookup(struct tree *tree, const char *s)
+utf8lookup(struct tree *tree, unsigned char *hangul, const char *s)
 {
-	return utf8nlookup(tree, s, (size_t)-1);
+	return utf8nlookup(tree, hangul, s, (size_t)-1);
 }
 
 /*
@@ -2624,13 +2828,15 @@ int
 utf8agemax(struct tree *tree, const char *s)
 {
 	utf8leaf_t	*leaf;
-	int		age = 0;
+	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
+	age = 0;
 	while (*s) {
-		if (!(leaf = utf8lookup(tree, s)))
+		if (!(leaf = utf8lookup(tree, hangul, s)))
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age > age)
@@ -2649,13 +2855,15 @@ int
 utf8agemin(struct tree *tree, const char *s)
 {
 	utf8leaf_t	*leaf;
-	int		age = tree->maxage;
+	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
+	age = tree->maxage;
 	while (*s) {
-		if (!(leaf = utf8lookup(tree, s)))
+		if (!(leaf = utf8lookup(tree, hangul, s)))
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age < age)
@@ -2673,13 +2881,15 @@ int
 utf8nagemax(struct tree *tree, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
-	int		age = 0;
+	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
+	age = 0;
         while (len && *s) {
-		if (!(leaf = utf8nlookup(tree, s, len)))
+		if (!(leaf = utf8nlookup(tree, hangul, s, len)))
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age > age)
@@ -2699,12 +2909,14 @@ utf8nagemin(struct tree *tree, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
 	int		leaf_age;
-	int		age = tree->maxage;
+	int		age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
+	age = tree->maxage;
         while (len && *s) {
-		if (!(leaf = utf8nlookup(tree, s, len)))
+		if (!(leaf = utf8nlookup(tree, hangul, s, len)))
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age < age)
@@ -2726,11 +2938,12 @@ utf8len(struct tree *tree, const char *s)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
 	while (*s) {
-		if (!(leaf = utf8lookup(tree, s)))
+		if (!(leaf = utf8lookup(tree, hangul, s)))
 			return -1;
 		if (ages[LEAF_GEN(leaf)] > tree->maxage)
 			ret += utf8clen(s);
@@ -2752,11 +2965,12 @@ utf8nlen(struct tree *tree, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
 	while (len && *s) {
-		if (!(leaf = utf8nlookup(tree, s, len)))
+		if (!(leaf = utf8nlookup(tree, hangul, s, len)))
 			return -1;
 		if (ages[LEAF_GEN(leaf)] > tree->maxage)
 			ret += utf8clen(s);
@@ -2784,6 +2998,7 @@ struct utf8cursor {
 	short int	ccc;
 	short int	nccc;
 	unsigned int	unichar;
+	unsigned char	hangul[UTF8HANGULLEAF];
 };
 
 /*
@@ -2900,10 +3115,12 @@ utf8byte(struct utf8cursor *u8c)
 		}
 
 		/* Look up the data for the current character. */
-		if (u8c->p)
-			leaf = utf8lookup(u8c->tree, u8c->s);
-		else
-			leaf = utf8nlookup(u8c->tree, u8c->s, u8c->len);
+		if (u8c->p) {
+			leaf = utf8lookup(u8c->tree, u8c->hangul, u8c->s);
+		} else {
+			leaf = utf8nlookup(u8c->tree, u8c->hangul,
+					   u8c->s, u8c->len);
+		}
 
 		/* No leaf found implies that the input is a binary blob. */
 		if (!leaf)
@@ -2923,10 +3140,10 @@ utf8byte(struct utf8cursor *u8c)
 				ccc = STOPPER;
 				goto ccc_mismatch;
 			}
-			leaf = utf8lookup(u8c->tree, u8c->s);
+			leaf = utf8lookup(u8c->tree, u8c->hangul, u8c->s);
 			ccc = LEAF_CCC(leaf);
 		}
-		u8c->unichar = utf8code(u8c->s);
+		u8c->unichar = utf8decode(u8c->s);
 
 		/*
 		 * If this is not a stopper, then see if it updates
@@ -3055,7 +3272,7 @@ normalization_test(void)
 		t = buf2;
 		while (*s) {
 			unichar = strtoul(s, &s, 16);
-			t += utf8key(unichar, t);
+			t += utf8encode(t, unichar);
 		}
 		*t = '\0';
 
@@ -3068,13 +3285,13 @@ normalization_test(void)
 			if (data->utf8nfkdi && !*data->utf8nfkdi)
 				ignorables = 1;
 			else
-				t += utf8key(unichar, t);
+				t += utf8encode(t, unichar);
 		}
 		*t = '\0';
 
 		tests++;
 		if (normalize_line(nfkdi_tree) < 0) {
-			printf("\nline %s -> %s", buf0, buf1);
+			printf("Line %s -> %s", buf0, buf1);
 			if (ignorables)
 				printf(" (ignorables removed)");
 			printf(" failure\n");
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
