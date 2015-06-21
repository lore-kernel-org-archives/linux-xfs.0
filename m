Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6488C29E00
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 577B8304051
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JMhuj4qyM7oMSH8z (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:07 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bTx-0001zA-Pm
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] xfsprogs: remove register keywords
Date: Sun, 21 Jun 2015 11:21:57 +0200
Message-Id: <1434878524-18176-2-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libhandle/jdm.c |   8 ++--
 repair/avl.c    | 130 ++++++++++++++++++++++++++---------------------------
 repair/avl.h    |   8 ++--
 repair/avl64.c  | 136 ++++++++++++++++++++++++++++----------------------------
 repair/avl64.h  |   6 +--
 rtcp/xfs_rtcp.c |   2 +-
 6 files changed, 145 insertions(+), 145 deletions(-)

diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 070407b..e177b2a 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -111,7 +111,7 @@ jdm_delete_filehandle( jdm_filehandle_t *handlep, size_t hlen )
 intgen_t
 jdm_open( jdm_fshandle_t *fshp, xfs_bstat_t *statp, intgen_t oflags )
 {
-	register fshandle_t *fshandlep = ( fshandle_t * )fshp;
+	fshandle_t *fshandlep = ( fshandle_t * )fshp;
 	filehandle_t filehandle;
 	intgen_t fd;
 
@@ -127,7 +127,7 @@ jdm_readlink( jdm_fshandle_t *fshp,
 	      xfs_bstat_t *statp,
 	      char *bufp, size_t bufsz )
 {
-	register fshandle_t *fshandlep = ( fshandle_t * )fshp;
+	fshandle_t *fshandlep = ( fshandle_t * )fshp;
 	filehandle_t filehandle;
 	intgen_t rval;
 
@@ -144,7 +144,7 @@ jdm_attr_multi(	jdm_fshandle_t *fshp,
 		xfs_bstat_t *statp,
 		char *bufp, int rtrvcnt, int flags)
 {
-	register fshandle_t *fshandlep = ( fshandle_t * )fshp;
+	fshandle_t *fshandlep = ( fshandle_t * )fshp;
 	filehandle_t filehandle;
 	int rval;
 
@@ -162,7 +162,7 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 		char *bufp, size_t bufsz, int flags,
 		struct attrlist_cursor *cursor)
 {
-	register fshandle_t *fshandlep = ( fshandle_t * )fshp;
+	fshandle_t *fshandlep = ( fshandle_t * )fshp;
 	filehandle_t filehandle;
 	int rval;
 
diff --git a/repair/avl.c b/repair/avl.c
index eabecc3..c5ff919 100644
--- a/repair/avl.c
+++ b/repair/avl.c
@@ -25,13 +25,13 @@
 
 static void
 avl_checknode(
-	register avltree_desc_t *tree,
-	register avlnode_t *np)
+	avltree_desc_t *tree,
+	avlnode_t *np)
 {
-	register avlnode_t *back = np->avl_back;
-	register avlnode_t *forw = np->avl_forw;
-	register avlnode_t *nextino = np->avl_nextino;
-	register int bal = np->avl_balance;
+	avlnode_t *back = np->avl_back;
+	avlnode_t *forw = np->avl_forw;
+	avlnode_t *nextino = np->avl_nextino;
+	int bal = np->avl_balance;
 
 	ASSERT(bal != AVL_BALANCE || (!back && !forw) || (back && forw));
 	ASSERT(bal != AVL_FORW || forw);
@@ -65,10 +65,10 @@ avl_checknode(
 
 static void
 avl_checktree(
-	register avltree_desc_t *tree,
-	register avlnode_t *root)
+	avltree_desc_t *tree,
+	avlnode_t *root)
 {
-	register avlnode_t *nlast, *nnext, *np;
+	avlnode_t *nlast, *nnext, *np;
 	__psunsigned_t offset = 0;
 	__psunsigned_t end;
 
@@ -123,14 +123,14 @@ avl_checktree(
 static void
 retreat(
 	avltree_desc_t *tree,
-	register avlnode_t *np,
-	register int direction)
+	avlnode_t *np,
+	int direction)
 {
-	register avlnode_t **rootp = &tree->avl_root;
-	register avlnode_t *parent;
-	register avlnode_t *child;
-	register avlnode_t *tmp;
-	register int	bal;
+	avlnode_t **rootp = &tree->avl_root;
+	avlnode_t *parent;
+	avlnode_t *child;
+	avlnode_t *tmp;
+	int	bal;
 
 	do {
 		ASSERT(direction == AVL_BACK || direction == AVL_FORW);
@@ -384,13 +384,13 @@ next:
  */
 void
 avl_delete(
-	register avltree_desc_t *tree,
-	register avlnode_t *np)
+	avltree_desc_t *tree,
+	avlnode_t *np)
 {
-	register avlnode_t *forw = np->avl_forw;
-	register avlnode_t *back = np->avl_back;
-	register avlnode_t *parent = np->avl_parent;
-	register avlnode_t *nnext;
+	avlnode_t *forw = np->avl_forw;
+	avlnode_t *back = np->avl_back;
+	avlnode_t *parent = np->avl_parent;
+	avlnode_t *nnext;
 
 
 	if (np->avl_back) {
@@ -588,12 +588,12 @@ attach:
  */
 avlnode_t *
 avl_findanyrange(
-	register avltree_desc_t *tree,
-	register __psunsigned_t start,
-	register __psunsigned_t end,
+	avltree_desc_t *tree,
+	__psunsigned_t start,
+	__psunsigned_t end,
 	int	checklen)
 {
-	register avlnode_t *np = tree->avl_root;
+	avlnode_t *np = tree->avl_root;
 
 	/* np = avl_findadjacent(tree, start, AVL_SUCCEED); */
 	while (np) {
@@ -659,11 +659,11 @@ avl_findanyrange(
  */
 avlnode_t *
 avl_find(
-	register avltree_desc_t *tree,
-	register __psunsigned_t value)
+	avltree_desc_t *tree,
+	__psunsigned_t value)
 {
-	register avlnode_t *np = tree->avl_root;
-	register __psunsigned_t nvalue;
+	avlnode_t *np = tree->avl_root;
+	__psunsigned_t nvalue;
 
 	while (np) {
 		nvalue = AVL_START(tree, np);
@@ -686,9 +686,9 @@ avl_find(
  */
 static void
 avl_balance(
-	register avlnode_t **rootp,
-	register avlnode_t *np,
-	register int growth)
+	avlnode_t **rootp,
+	avlnode_t *np,
+	int growth)
 {
 	/*
 	 * At this point, np points to the node to which
@@ -696,8 +696,8 @@ avl_balance(
 	 * propagate avl_balance up the tree.
 	 */
 	for ( ; ; ) {
-		register avlnode_t *parent = np->avl_parent;
-		register avlnode_t *child;
+		avlnode_t *parent = np->avl_parent;
+		avlnode_t *child;
 
 		CERT(growth == AVL_BACK || growth == AVL_FORW);
 
@@ -777,7 +777,7 @@ avl_balance(
 						D
 
 				 */
-				register avlnode_t *tmp = child->avl_forw;
+				avlnode_t *tmp = child->avl_forw;
 
 				CERT(child->avl_balance == AVL_FORW && tmp);
 
@@ -834,7 +834,7 @@ avl_balance(
 				/*
 				 * double RL
 				 */
-				register avlnode_t *tmp = child->avl_back;
+				avlnode_t *tmp = child->avl_back;
 
 				ASSERT(child->avl_balance == AVL_BACK && tmp);
 
@@ -886,13 +886,13 @@ avl_balance(
 static
 avlnode_t *
 avl_insert_find_growth(
-		register avltree_desc_t *tree,
-		register __psunsigned_t start,	/* range start at start, */
-		register __psunsigned_t end,	/* exclusive */
-		register int   *growthp)	/* OUT */
+		avltree_desc_t *tree,
+		__psunsigned_t start,	/* range start at start, */
+		__psunsigned_t end,	/* exclusive */
+		int   *growthp)	/* OUT */
 {
 	avlnode_t *root = tree->avl_root;
-	register avlnode_t *np;
+	avlnode_t *np;
 
 	np = root;
 	ASSERT(np); /* caller ensures that there is atleast one node in tree */
@@ -935,13 +935,13 @@ avl_insert_find_growth(
 
 static void
 avl_insert_grow(
-	register avltree_desc_t *tree,
-	register avlnode_t *parent,
-	register avlnode_t *newnode,
-	register int growth)
+	avltree_desc_t *tree,
+	avlnode_t *parent,
+	avlnode_t *newnode,
+	int growth)
 {
-	register avlnode_t *nnext;
-	register __psunsigned_t start = AVL_START(tree, newnode);
+	avlnode_t *nnext;
+	__psunsigned_t start = AVL_START(tree, newnode);
 
 	if (growth == AVL_BACK) {
 
@@ -979,12 +979,12 @@ avl_insert_grow(
 
 avlnode_t *
 avl_insert(
-	register avltree_desc_t *tree,
-	register avlnode_t *newnode)
+	avltree_desc_t *tree,
+	avlnode_t *newnode)
 {
-	register avlnode_t *np;
-	register __psunsigned_t start = AVL_START(tree, newnode);
-	register __psunsigned_t end = AVL_END(tree, newnode);
+	avlnode_t *np;
+	__psunsigned_t start = AVL_START(tree, newnode);
+	__psunsigned_t end = AVL_END(tree, newnode);
 	int growth;
 
 	ASSERT(newnode);
@@ -1081,9 +1081,9 @@ avl_insert_immediate(
  *	Returns first in order node
  */
 avlnode_t *
-avl_firstino(register avlnode_t *root)
+avl_firstino(avlnode_t *root)
 {
-	register avlnode_t *np;
+	avlnode_t *np;
 
 	if ((np = root) == NULL)
 		return NULL;
@@ -1097,9 +1097,9 @@ avl_firstino(register avlnode_t *root)
  *	Returns last in order node
  */
 avlnode_t *
-avl_lastino(register avlnode_t *root)
+avl_lastino(avlnode_t *root)
 {
-	register avlnode_t *np;
+	avlnode_t *np;
 
 	if ((np = root) == NULL)
 		return NULL;
@@ -1282,11 +1282,11 @@ main()
  */
 avlnode_t *
 avl_findadjacent(
-	register avltree_desc_t *tree,
-	register __psunsigned_t value,
-	register int		dir)
+	avltree_desc_t *tree,
+	__psunsigned_t value,
+	int		dir)
 {
-	register avlnode_t *np = tree->avl_root;
+	avlnode_t *np = tree->avl_root;
 
 	while (np) {
 		if (value < AVL_START(tree, np)) {
@@ -1356,13 +1356,13 @@ avl_findadjacent(
 
 void
 avl_findranges(
-	register avltree_desc_t *tree,
-	register __psunsigned_t start,
-	register __psunsigned_t end,
+	avltree_desc_t *tree,
+	__psunsigned_t start,
+	__psunsigned_t end,
 	avlnode_t	        **startp,
 	avlnode_t		**endp)
 {
-	register avlnode_t *np;
+	avlnode_t *np;
 
 	np = avl_findadjacent(tree, start, AVL_SUCCEED);
 	if (np == NULL				/* nothing succeding start */
diff --git a/repair/avl.h b/repair/avl.h
index 2fad1ec..0078a95 100644
--- a/repair/avl.h
+++ b/repair/avl.h
@@ -89,7 +89,7 @@ avl_findrange(
 	avltree_desc_t *tree,
 	__psunsigned_t value)
 {
-	register avlnode_t *np = tree->avl_root;
+	avlnode_t *np = tree->avl_root;
 
 	while (np) {
 		if (value < AVL_START(tree, np)) {
@@ -128,9 +128,9 @@ avl_findadjacent(
 
 void
 avl_findranges(
-	register avltree_desc_t *tree,
-	register __psunsigned_t start,
-	register __psunsigned_t end,
+	avltree_desc_t *tree,
+	__psunsigned_t start,
+	__psunsigned_t end,
 	avlnode_t	        **startp,
 	avlnode_t		**endp);
 
diff --git a/repair/avl64.c b/repair/avl64.c
index c135da3..32217fe 100644
--- a/repair/avl64.c
+++ b/repair/avl64.c
@@ -26,13 +26,13 @@
 
 static void
 avl64_checknode(
-	register avl64tree_desc_t *tree,
-	register avl64node_t *np)
+	avl64tree_desc_t *tree,
+	avl64node_t *np)
 {
-	register avl64node_t *back = np->avl_back;
-	register avl64node_t *forw = np->avl_forw;
-	register avl64node_t *nextino = np->avl_nextino;
-	register int bal = np->avl_balance;
+	avl64node_t *back = np->avl_back;
+	avl64node_t *forw = np->avl_forw;
+	avl64node_t *nextino = np->avl_nextino;
+	int bal = np->avl_balance;
 
 	ASSERT(bal != AVL_BALANCE || (!back && !forw) || (back && forw));
 	ASSERT(bal != AVL_FORW || forw);
@@ -66,10 +66,10 @@ avl64_checknode(
 
 static void
 avl64_checktree(
-	register avl64tree_desc_t *tree,
-	register avl64node_t *root)
+	avl64tree_desc_t *tree,
+	avl64node_t *root)
 {
-	register avl64node_t *nlast, *nnext, *np;
+	avl64node_t *nlast, *nnext, *np;
 	__uint64_t offset = 0;
 	__uint64_t end;
 
@@ -124,14 +124,14 @@ avl64_checktree(
 static void
 retreat(
 	avl64tree_desc_t *tree,
-	register avl64node_t *np,
-	register int direction)
+	avl64node_t *np,
+	int direction)
 {
-	register avl64node_t **rootp = &tree->avl_root;
-	register avl64node_t *parent;
-	register avl64node_t *child;
-	register avl64node_t *tmp;
-	register int	bal;
+	avl64node_t **rootp = &tree->avl_root;
+	avl64node_t *parent;
+	avl64node_t *child;
+	avl64node_t *tmp;
+	int	bal;
 
 	do {
 		ASSERT(direction == AVL_BACK || direction == AVL_FORW);
@@ -378,13 +378,13 @@ next:
  */
 void
 avl64_delete(
-	register avl64tree_desc_t *tree,
-	register avl64node_t *np)
+	avl64tree_desc_t *tree,
+	avl64node_t *np)
 {
-	register avl64node_t *forw = np->avl_forw;
-	register avl64node_t *back = np->avl_back;
-	register avl64node_t *parent = np->avl_parent;
-	register avl64node_t *nnext;
+	avl64node_t *forw = np->avl_forw;
+	avl64node_t *back = np->avl_back;
+	avl64node_t *parent = np->avl_parent;
+	avl64node_t *nnext;
 
 
 	if (np->avl_back) {
@@ -582,12 +582,12 @@ attach:
  */
 avl64node_t *
 avl64_findanyrange(
-	register avl64tree_desc_t *tree,
-	register __uint64_t start,
-	register __uint64_t end,
+	avl64tree_desc_t *tree,
+	__uint64_t start,
+	__uint64_t end,
 	int	checklen)
 {
-	register avl64node_t *np = tree->avl_root;
+	avl64node_t *np = tree->avl_root;
 
 	/* np = avl64_findadjacent(tree, start, AVL_SUCCEED); */
 	while (np) {
@@ -654,10 +654,10 @@ avl64_findanyrange(
  */
 avl64node_t *
 avl64_findrange(
-	register avl64tree_desc_t *tree,
-	register __uint64_t value)
+	avl64tree_desc_t *tree,
+	__uint64_t value)
 {
-	register avl64node_t *np = tree->avl_root;
+	avl64node_t *np = tree->avl_root;
 
 	while (np) {
 		if (value < AVL_START(tree, np)) {
@@ -681,11 +681,11 @@ avl64_findrange(
  */
 avl64node_t *
 avl64_find(
-	register avl64tree_desc_t *tree,
-	register __uint64_t value)
+	avl64tree_desc_t *tree,
+	__uint64_t value)
 {
-	register avl64node_t *np = tree->avl_root;
-	register __uint64_t nvalue;
+	avl64node_t *np = tree->avl_root;
+	__uint64_t nvalue;
 
 	while (np) {
 		nvalue = AVL_START(tree, np);
@@ -708,9 +708,9 @@ avl64_find(
  */
 static void
 avl64_balance(
-	register avl64node_t **rootp,
-	register avl64node_t *np,
-	register int growth)
+	avl64node_t **rootp,
+	avl64node_t *np,
+	int growth)
 {
 	/*
 	 * At this point, np points to the node to which
@@ -718,8 +718,8 @@ avl64_balance(
 	 * propagate avl_balance up the tree.
 	 */
 	for ( ; ; ) {
-		register avl64node_t *parent = np->avl_parent;
-		register avl64node_t *child;
+		avl64node_t *parent = np->avl_parent;
+		avl64node_t *child;
 
 		CERT(growth == AVL_BACK || growth == AVL_FORW);
 
@@ -799,7 +799,7 @@ avl64_balance(
 						D
 
 				 */
-				register avl64node_t *tmp = child->avl_forw;
+				avl64node_t *tmp = child->avl_forw;
 
 				CERT(child->avl_balance == AVL_FORW && tmp);
 
@@ -856,7 +856,7 @@ avl64_balance(
 				/*
 				 * double RL
 				 */
-				register avl64node_t *tmp = child->avl_back;
+				avl64node_t *tmp = child->avl_back;
 
 				ASSERT(child->avl_balance == AVL_BACK && tmp);
 
@@ -908,13 +908,13 @@ avl64_balance(
 static
 avl64node_t *
 avl64_insert_find_growth(
-		register avl64tree_desc_t *tree,
-		register __uint64_t start,	/* range start at start, */
-		register __uint64_t end,	/* exclusive */
-		register int   *growthp)	/* OUT */
+		avl64tree_desc_t *tree,
+		__uint64_t start,	/* range start at start, */
+		__uint64_t end,	/* exclusive */
+		int   *growthp)	/* OUT */
 {
 	avl64node_t *root = tree->avl_root;
-	register avl64node_t *np;
+	avl64node_t *np;
 
 	np = root;
 	ASSERT(np); /* caller ensures that there is atleast one node in tree */
@@ -957,13 +957,13 @@ avl64_insert_find_growth(
 
 static void
 avl64_insert_grow(
-	register avl64tree_desc_t *tree,
-	register avl64node_t *parent,
-	register avl64node_t *newnode,
-	register int growth)
+	avl64tree_desc_t *tree,
+	avl64node_t *parent,
+	avl64node_t *newnode,
+	int growth)
 {
-	register avl64node_t *nnext;
-	register __uint64_t start = AVL_START(tree, newnode);
+	avl64node_t *nnext;
+	__uint64_t start = AVL_START(tree, newnode);
 
 	if (growth == AVL_BACK) {
 
@@ -1001,12 +1001,12 @@ avl64_insert_grow(
 
 avl64node_t *
 avl64_insert(
-	register avl64tree_desc_t *tree,
-	register avl64node_t *newnode)
+	avl64tree_desc_t *tree,
+	avl64node_t *newnode)
 {
-	register avl64node_t *np;
-	register __uint64_t start = AVL_START(tree, newnode);
-	register __uint64_t end = AVL_END(tree, newnode);
+	avl64node_t *np;
+	__uint64_t start = AVL_START(tree, newnode);
+	__uint64_t end = AVL_END(tree, newnode);
 	int growth;
 
 	ASSERT(newnode);
@@ -1102,9 +1102,9 @@ avl64_insert_immediate(
  *	Returns first in order node
  */
 avl64node_t *
-avl64_firstino(register avl64node_t *root)
+avl64_firstino(avl64node_t *root)
 {
-	register avl64node_t *np;
+	avl64node_t *np;
 
 	if ((np = root) == NULL)
 		return NULL;
@@ -1118,9 +1118,9 @@ avl64_firstino(register avl64node_t *root)
  *	Returns last in order node
  */
 avl64node_t *
-avl64_lastino(register avl64node_t *root)
+avl64_lastino(avl64node_t *root)
 {
-	register avl64node_t *np;
+	avl64node_t *np;
 
 	if ((np = root) == NULL)
 		return NULL;
@@ -1303,11 +1303,11 @@ main()
  */
 avl64node_t *
 avl64_findadjacent(
-	register avl64tree_desc_t *tree,
-	register __uint64_t value,
-	register int		dir)
+	avl64tree_desc_t *tree,
+	__uint64_t value,
+	int		dir)
 {
-	register avl64node_t *np = tree->avl_root;
+	avl64node_t *np = tree->avl_root;
 
 	while (np) {
 		if (value < AVL_START(tree, np)) {
@@ -1377,13 +1377,13 @@ avl64_findadjacent(
 
 void
 avl64_findranges(
-	register avl64tree_desc_t *tree,
-	register __uint64_t start,
-	register __uint64_t end,
+	avl64tree_desc_t *tree,
+	__uint64_t start,
+	__uint64_t end,
 	avl64node_t	        **startp,
 	avl64node_t		**endp)
 {
-	register avl64node_t *np;
+	avl64node_t *np;
 
 	np = avl64_findadjacent(tree, start, AVL_SUCCEED);
 	if (np == NULL				/* nothing succeding start */
diff --git a/repair/avl64.h b/repair/avl64.h
index 922e284..fd19321 100644
--- a/repair/avl64.h
+++ b/repair/avl64.h
@@ -112,9 +112,9 @@ avl64_findadjacent(
 
 void
 avl64_findranges(
-	register avl64tree_desc_t *tree,
-	register __uint64_t	start,
-	register __uint64_t	end,
+	avl64tree_desc_t *tree,
+	__uint64_t	start,
+	__uint64_t	end,
 	avl64node_t	        **startp,
 	avl64node_t		**endp);
 
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index 5f26a62..11b5d38 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -34,7 +34,7 @@ usage(void)
 int
 main(int argc, char **argv)
 {
-	register int	c, i, r, errflg = 0;
+	int	c, i, r, errflg = 0;
 	struct stat64	s2;
 	int		extsize = - 1;
 
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
