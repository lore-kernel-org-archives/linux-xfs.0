Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45561 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbeKJAMv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:51 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3385D4E936
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:59 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 14/24] xfsdump: (3/4)(style) add first empty line for multiline comments
Date: Fri,  9 Nov 2018 15:29:54 +0100
Message-Id: <20181109143004.24963-15-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Change the multiline comment style from /* foo to /*
 * foo

Created by this script:

#!/usr/bin/env bash
# change the multiline comment style from /* foo to /*
 * foo

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/^\(\s*\)\/\* \(.\+[^*][^/]\)$/\1\/*
\1 * \2/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 restore/bag.c     |    9 +-
 restore/bag.h     |   27 +-
 restore/content.c | 1368 ++++++++++++++++++++++++++++++---------------
 restore/dirattr.c |  156 ++++--
 restore/dirattr.h |   30 +-
 restore/getopt.h  |    3 +-
 restore/inomap.c  |  132 +++--
 restore/inomap.h  |    9 +-
 restore/namreg.c  |   99 ++--
 restore/namreg.h  |   21 +-
 restore/node.c    |  135 +++--
 restore/node.h    |   21 +-
 restore/tree.c    |  762 ++++++++++++++++---------
 restore/tree.h    |   33 +-
 restore/win.c     |   93 ++-
 restore/win.h     |   12 +-
 16 files changed, 1940 insertions(+), 970 deletions(-)

diff --git a/restore/bag.c b/restore/bag.c
index 8a8bda4..e209bfc 100644
--- a/restore/bag.c
+++ b/restore/bag.c
@@ -146,18 +146,21 @@ bagiter_next(bagiter_t *iterp, void **payloadpp)
 {
 	bagelem_t *returnp;
 
-	/* termination condition
+	/*
+	 * termination condition
 	 */
 	if (! iterp->bi_nextp) {
 		*payloadpp = 0;
 		return 0;
 	}
 
-	/* save the element to be returned
+	/*
+	 * save the element to be returned
 	 */
 	returnp = iterp->bi_nextp;
 
-	/* calculate next. if returning last, set next to NULL
+	/*
+	 * calculate next. if returning last, set next to NULL
 	 */
 	if (iterp->bi_nextp == iterp->bi_lastp) {
 		iterp->bi_nextp = 0;
diff --git a/restore/bag.h b/restore/bag.h
index c2aef2c..67ba30c 100644
--- a/restore/bag.h
+++ b/restore/bag.h
@@ -18,7 +18,8 @@
 #ifndef BAG_H
 #define BAG_H
 
-/* bag.[hc] - bag abstraction
+/*
+ * bag.[hc] - bag abstraction
  *
  * user embeds a bagelem_t into items to be bagged. the element contains
  * an element key, and a user-specified pointer. items can be inserted
@@ -43,11 +44,13 @@ struct bag {
 
 typedef struct bag bag_t;
 
-/* creates a new bag
+/*
+ * creates a new bag
  */
 extern bag_t *bag_alloc(void);
 
-/* insert the item into the bag. the caller supplies a search key
+/*
+ * insert the item into the bag. the caller supplies a search key
  * and arbitrary payload.
  */
 extern void bag_insert(bag_t *bagp,
@@ -55,7 +58,8 @@ extern void bag_insert(bag_t *bagp,
 			size64_t key,
 			void *payloadp);
 
-/* remove the item from the bag. the key and payload originally supplied
+/*
+ * remove the item from the bag. the key and payload originally supplied
  * to the insert operator are returned by reference.
  */
 extern void bag_remove(bag_t *bagp,
@@ -63,7 +67,8 @@ extern void bag_remove(bag_t *bagp,
 			size64_t *keyp,
 			void **payloadpp);
 
-/* search by key for an element in the bag.
+/*
+ * search by key for an element in the bag.
  * returns the element pointer if a matching item is found, as well as
  * the payload (by reference). if the item is not in the bag, returns
  * a null pointer and (by reference) payload.
@@ -72,7 +77,8 @@ extern bagelem_t *bag_find(bag_t *bagp,
 			    size64_t key,
 			    void **payloadpp);
 
-/* private bag iterator
+/*
+ * private bag iterator
  */
 struct bagiter {
 	bag_t *bi_bagp;
@@ -82,16 +88,19 @@ struct bagiter {
 
 typedef struct bagiter bagiter_t;
 
-/* initializes a bag iterator
+/*
+ * initializes a bag iterator
  */
 extern void bagiter_init(bag_t *bagp, bagiter_t *iterp);
 
-/* returns the next element in the bag. caller may remove the element
+/*
+ * returns the next element in the bag. caller may remove the element
  * prior to the next call.
  */
 extern bagelem_t * bagiter_next(bagiter_t *iterp, void **payloadpp);
 
-/* destroys the bag.
+/*
+ * destroys the bag.
  */
 extern void bag_free(bag_t *bagp);
 
diff --git a/restore/content.c b/restore/content.c
index b616eda..a97d9e3 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -71,60 +71,74 @@
 #include "win.h"
 #include "hsmapi.h"
 
-/* content.c - manages restore content
+/*
+ * content.c - manages restore content
  */
 
 /* structure definitions used locally ****************************************/
 
 #define HOUSEKEEPING_MAGIC	0x686b6d61
-	/* "hkma" - see the housekeeping_magic field of pers_t below.
+	/*
+	 * "hkma" - see the housekeeping_magic field of pers_t below.
 	 */
 #define HOUSEKEEPING_VERSION	2
-	/* see the housekeeping_version field of pers_t below.
+	/*
+	 * see the housekeeping_version field of pers_t below.
 	 * version 2 changed the size of a gen_t, which caused node_t
 	 * to change in size. also p_truncategenpr was added to treepers_t.
 	 */
 
 #define WRITE_TRIES_MAX	3
-	/* retry loop tuning for write(2) workaround
+	/*
+	 * retry loop tuning for write(2) workaround
 	 */
 typedef enum { SYNC_INIT, SYNC_BUSY, SYNC_DONE } sync_t;
-	/* for lock-step synchronization
+	/*
+	 * for lock-step synchronization
 	 */
 typedef struct { xfs_ino_t eg_ino; off64_t eg_off; } egrp_t;
-	/* extent group descriptor
+	/*
+	 * extent group descriptor
 	 */
 typedef char label_t[GLOBAL_HDR_STRING_SZ];
-	/* dump or mobj label
+	/*
+	 * dump or mobj label
 	 */
 typedef enum { PURP_SEARCH, PURP_DIR, PURP_NONDIR } purp_t;
-	/* to describe purpose for a media file request. may be for
+	/*
+	 * to describe purpose for a media file request. may be for
 	 * searching for a dump to restore, for dir restore, or non-dir
 	 */
 typedef off_t dh_t;
-	/* handles for descriptors in persistent state inventory
+	/*
+	 * handles for descriptors in persistent state inventory
 	 * encoded as byte offset plus one of descriptor into descriptor
 	 * portion of persistent state. plus one so DH_NULL can be zero.
 	 */
 #define DH_NULL		((dh_t)0)
-	/* NULL inv. descriptor handles, to terminate linked descriptor lists.
+	/*
+	 * NULL inv. descriptor handles, to terminate linked descriptor lists.
 	 * must be zero-valued, so memset of pers.s sets freeh to DH_NULL.
 	 */
 #define DH2F(h)	((pers_file_t *)((char *)descp + (h - 1)))
 #define DH2O(h)	((pers_obj_t *)((char *)descp + (h - 1)))
 #define DH2S(h)	((pers_strm_t *)((char *)descp + (h - 1)))
 #define DH2D(h)	((pers_desc_t *)((char *)descp + (h - 1)))
-	/* convert file, object, and stream inv. descriptor handle into
+	/*
+	 * convert file, object, and stream inv. descriptor handle into
 	 * descriptor pointers
 	 */
 #define DAU		1
-	/* number of descriptor pages to allocate when free list exhausted
+	/*
+	 * number of descriptor pages to allocate when free list exhausted
 	 */
 #define IBPGINCR	32
-	/* session inv. restore retry buffer increment
+	/*
+	 * session inv. restore retry buffer increment
 	 */
 
-/* Media state abstraction
+/*
+ * Media state abstraction
  */
 struct Media {
 	drive_t *M_drivep;
@@ -142,7 +156,8 @@ struct Media {
 	       POS_USELESS,	/* current object contains nothing useful */
 	       POS_BLANK	/* like useless */
 	} M_pos;
-		/* media positioning info. initially UNKN, set back to
+		/*
+		 * media positioning info. initially UNKN, set back to
 		 * unkn whenever end_read op called.
 		 */
 	ix_t M_fmfix;
@@ -151,7 +166,8 @@ struct Media {
 	bool_t M_pmfixvalpr;
 	purp_t M_mfixpurp;
 	bool_t M_flmfixvalpr;
-		/* the indices within the current media object of the first
+		/*
+		 * the indices within the current media object of the first
 		 * and last media files seen, as well as previous last.
 		 * invalidated whenever purpose changes or media is changed.
 		 * previous (pmfix) not valid until second media file seen.
@@ -160,7 +176,8 @@ struct Media {
 	ix_t M_fsoix;
 	ix_t M_fssix;
 	bool_t M_fsfixvalpr;
-		/* index within the current media object of the first
+		/*
+		 * index within the current media object of the first
 		 * media file that is part of dump being restored,
 		 * and indices of the obj and stream containing that mfile.
 		 * invalidated on media change.
@@ -170,155 +187,192 @@ struct Media {
 typedef struct Media Media_t;
 
 
-/* persistent state - mmapped, has linked lists of dump streams, media
+/*
+ * persistent state - mmapped, has linked lists of dump streams, media
  * objects, and media files. descriptors for each fit into PERS_DESCSZ
  * bytes, and are allocated from a common free pool.
  */
 
-/* persistent media file descriptor
+/*
+ * persistent media file descriptor
  */
 struct pers_file {
 	dh_t f_nexth;
-		/* singly-linked list of files withing object
+		/*
+		 * singly-linked list of files withing object
 		 */
 	dh_t f_parh;
-		/* parent object
+		/*
+		 * parent object
 		 */
 	bool_t f_szvalpr;
 	off64_t f_sz;
-		/* if this info came from an inventory (on-line or on-media),
+		/*
+		 * if this info came from an inventory (on-line or on-media),
 		 * we know the media file size
 		 */
 	bool_t f_dirtriedpr;
-		/* set if attempted to restore dirs from this media file.
+		/*
+		 * set if attempted to restore dirs from this media file.
 		 * says nothing about success or failure. prevents us from
 		 * trying to restore dirs from this media file again.
 		 */
 	bool_t f_valpr;
-		/* following three fields are valid
+		/*
+		 * following three fields are valid
 		 */
 	egrp_t f_firstegrp;
-		/* first extent group in this media file
+		/*
+		 * first extent group in this media file
 		 */
 	egrp_t f_curegrp;
-		/* next extent group to be restored from this media file.
+		/*
+		 * next extent group to be restored from this media file.
 		 * initially equals f_firstegrp.
 		 */
 	drive_mark_t f_curmark;
-		/* drive manager mark for seeking to current extent group
+		/*
+		 * drive manager mark for seeking to current extent group
 		 */
 	bool_t f_nondirdonepr;
-		/* TRUE when non-dirs from this media file completely restored,
+		/*
+		 * TRUE when non-dirs from this media file completely restored,
 		 * or as restored as they can be (some or all lost due to
 		 * media corruption).
 		 */
 	bool_t f_nondirskippr;
-		/* no non-dirs are needed from this nmedia file (due to
+		/*
+		 * no non-dirs are needed from this nmedia file (due to
 		 * subtree or interactive selections)
 		 */
 	int f_flags;
-		/* mark terminators and inventories
+		/*
+		 * mark terminators and inventories
 		 */
 	bool_t f_underheadpr;
-		/* the drive is currently positioned at or in this media file
+		/*
+		 * the drive is currently positioned at or in this media file
 		 */
 };
 
-/* f_flags
+/*
+ * f_flags
  */
 #define PF_INV	(1 << 0)
 #define PF_TERM	(1 << 1)
 
 typedef struct pers_file pers_file_t;
 
-/* persistent media object descriptor
+/*
+ * persistent media object descriptor
  */
 struct pers_obj {
 	dh_t o_nexth;
-		/* singly-linked list of objects in stream
+		/*
+		 * singly-linked list of objects in stream
 		 */
 	dh_t o_parh;
-		/* parent dump stream descriptor
+		/*
+		 * parent dump stream descriptor
 		 */
 	dh_t o_cldh;
-		/* head of list of pertinent media files contained in
+		/*
+		 * head of list of pertinent media files contained in
 		 * this media object
 		 */
 	bool_t o_idlabvalpr;
-		/* id and label fields are valid
+		/*
+		 * id and label fields are valid
 		 */
 	uuid_t o_id;
-		/* uuid of media object
+		/*
+		 * uuid of media object
 		 */
 	label_t o_lab;
-		/* label of media object
+		/*
+		 * label of media object
 		 */
 	ix_t o_fmfmix;
 	bool_t o_fmfmixvalpr;
-		/* 0-based index into this mobj's mfiles of first
+		/*
+		 * 0-based index into this mobj's mfiles of first
 		 * mfile in the mobj that is part of the dump stream.
 		 */
 	ix_t o_fmfsix;
 	bool_t o_fmfsixvalpr;
-		/* 0-based index into this dump stream's mfiles of first
+		/*
+		 * 0-based index into this dump stream's mfiles of first
 		 * mfile in the mobj that is part of the dump stream.
 		 */
 	bool_t o_lmfknwnpr;
-		/* TRUE if last media file on object is represented in
+		/*
+		 * TRUE if last media file on object is represented in
 		 * children list.
 		 */
 	bool_t o_indrivepr;
 	ix_t o_indriveix;
-		/* TRUE if this object is in a drive, and which drive it is
+		/*
+		 * TRUE if this object is in a drive, and which drive it is
 		 * in.
 		 */
 };
 
 typedef struct pers_obj pers_obj_t;
 
-/* media dump stream descriptor
+/*
+ * media dump stream descriptor
  */
 struct pers_strm {
 	dh_t s_nexth;
-		/* singly-linked list of streams generated by dump
+		/*
+		 * singly-linked list of streams generated by dump
 		 */
 	dh_t s_cldh;
-		/* head of list of mobjs containing this dstrm's mfiles
+		/*
+		 * head of list of mobjs containing this dstrm's mfiles
 		 */
 	bool_t s_lastobjknwnpr;
-		/* TRUE if if last object in the stream is represented in
+		/*
+		 * TRUE if if last object in the stream is represented in
 		 * children list.
 		 */
 };
 
 typedef struct pers_strm pers_strm_t;
 
-/* media descriptor allocation object (for free list)
+/*
+ * media descriptor allocation object (for free list)
  */
 union pers_desc {
 	dh_t d_nexth;
-		/* singly-linked free list of descriptors
+		/*
+		 * singly-linked free list of descriptors
 		 */
 	pers_file_t d_file;
-		/* media file descriptor overlay;
+		/*
+		 * media file descriptor overlay;
 		 */
 	pers_obj_t d_obj;
-		/* media object descriptor overlay;
+		/*
+		 * media object descriptor overlay;
 		 */
 	pers_strm_t d_strm;
-		/* media stream descriptor overlay;
+		/*
+		 * media stream descriptor overlay;
 		 */
 };
 
 typedef union pers_desc pers_desc_t;
 
 #define PERS_DESCSZ	512
-	/* size of media object, media file, and media stream descriptors.
+	/*
+	 * size of media object, media file, and media stream descriptors.
 	 * need to fit integral number into a page, single allocator
 	 * used allocate and free all types .
 	 */
 
-/* subtree descriptor - the subtree command line arguments are transcribed
+/*
+ * subtree descriptor - the subtree command line arguments are transcribed
  * into variable-length descriptors and placed in an integral number of
  * pages after the persistent header, and before the media descriptor free list.
  */
@@ -326,20 +380,24 @@ typedef union pers_desc pers_desc_t;
 
 struct stdesc {
 	bool_t std_sensepr;
-		/* TRUE if this is a subtree to INCLUDE, FALSE if EXCLUDE
+		/*
+		 * TRUE if this is a subtree to INCLUDE, FALSE if EXCLUDE
 		 */
 	off_t std_nextoff;
-		/* offset to next descriptor, in bytes relative to this
+		/*
+		 * offset to next descriptor, in bytes relative to this
 		 */
 	char std_path[1];
-		/* first character of a NULL-terminated string containing the
+		/*
+		 * first character of a NULL-terminated string containing the
 		 * the relative subtree pathname
 		 */
 };
 
 typedef struct stdesc stdesc_t;
 
-/* byte span descriptor - registers a span of a file restored.
+/*
+ * byte span descriptor - registers a span of a file restored.
  */
 struct bytespan {
 	off64_t	offset;
@@ -348,14 +406,16 @@ struct bytespan {
 
 typedef struct bytespan bytespan_t;
 
-/* partial restore descriptor - Keeps track of different byte spans restored
+/*
+ * partial restore descriptor - Keeps track of different byte spans restored
  * for a specific inode.  Used to sync operations between restore streams.
  */
 struct partial_rest {
 	xfs_ino_t	is_ino;
 		/* inode number */
 	bytespan_t is_bs[STREAM_SIMMAX];
-		/* each stream could conceivably be writing to a single
+		/*
+		 * each stream could conceivably be writing to a single
 		 * file simultaneously if one file spans all device streams.
 		 * Need a record for each possible place in the file.
 		 */
@@ -381,14 +441,16 @@ struct stream_context {
 
 typedef struct stream_context stream_context_t;
 
-/* persistent state file header - on-disk format information plus
+/*
+ * persistent state file header - on-disk format information plus
  * accumulation state (which spans several sessions) and session state.
  * the latter two have a valid bit, and their fields are not valid until
  * the valid bit is set. all elements defined such that a bzero results
  * in a valid initial state.
  */
 struct pers {
-	/* on-disk format information used to verify that xfsrestore
+	/*
+	 * on-disk format information used to verify that xfsrestore
 	 * can make sense of the data in xfsrestorehousekeepingdir
 	 * when running in cumulative mode or when resuming a restore.
 	 *
@@ -398,7 +460,8 @@ struct pers {
 	 */
 	struct {
 		size32_t housekeeping_magic;
-			/* used to determine if this struct has been
+			/*
+			 * used to determine if this struct has been
 			 * initialized, and whether the machine's
 			 * endianness is the same as the previous
 			 * invocation. (data written to xfsrestore's
@@ -407,23 +470,27 @@ struct pers {
 			 * for the life of one or more restore sessions.)
 			 */
 		size32_t housekeeping_version;
-			/* version of the data structures used in the
+			/*
+			 * version of the data structures used in the
 			 * state files in housekeepingdir. this must be
 			 * bumped whenever the on-disk format changes.
 			 */
 		size64_t pagesize;
-			/* headers in the persistent state files
+			/*
+			 * headers in the persistent state files
 			 * are aligned on page size boundaries, so
 			 * this cannot change betweeen invocations.
 			 */
 	} v;
 
-	/* command line arguments from first session, and session
+	/*
+	 * command line arguments from first session, and session
 	 * history.
 	 */
 	struct {
 		bool_t valpr;
-			/* not set until a BASE dump has been identified
+			/*
+			 * not set until a BASE dump has been identified
 			 * and validated for restoral, and an attempt has
 			 * been made to load the dump inventory into persistent
 			 * state, and the namreg and tree abstractions
@@ -431,66 +498,84 @@ struct pers {
 			 * has been initialized and validated.
 			 */
 		char dstdir[MAXPATHLEN];
-			/* absolute pathname of the destination directory
+			/*
+			 * absolute pathname of the destination directory
 			 */
 		bool_t dstdirisxfspr;
-			/* destination directory is an xfs filesystem; xfs-specific
+			/*
+			 * destination directory is an xfs filesystem; xfs-specific
 			 * calls can be made when needed.
 			 */
 		ix_t dumpcnt;
-			/* how many dumps have been applied completedly (A1)
+			/*
+			 * how many dumps have been applied completedly (A1)
 			 */
 		uuid_t lastdumpid;
-			/* uuid of the last dump completely restored (A1)
+			/*
+			 * uuid of the last dump completely restored (A1)
 			 */
 		label_t lastdumplab;
-			/* label of the last dump completely restored (A1)
+			/*
+			 * label of the last dump completely restored (A1)
 			 */
 		bool_t cumpr;
-			/* is a cumulative restore (-r)
+			/*
+			 * is a cumulative restore (-r)
 			 */
 		bool_t interpr;
-			/* interactive mode specified on command line (-i)
+			/*
+			 * interactive mode specified on command line (-i)
 			 */
 		bool_t existpr;
-			/* existing files may not be overwritten (-e)
+			/*
+			 * existing files may not be overwritten (-e)
 			 */
 		bool_t changepr;
-			/* only missing or old files may be overwritten (-E)
+			/*
+			 * only missing or old files may be overwritten (-E)
 			 */
 		bool_t newerpr;
 		time32_t newertime;
-			/* only files older than example may be overwritten (-n)
+			/*
+			 * only files older than example may be overwritten (-n)
 			 */
 		bool_t ownerpr;
-			/* attempt to restore owner/group (-o)
+			/*
+			 * attempt to restore owner/group (-o)
 			 */
 		ix_t stcnt;
-			/* how many subtree args (both inclusive and exclusive)
+			/*
+			 * how many subtree args (both inclusive and exclusive)
 			 * are recorded in the subtree pages (-s)
 			 */
 		bool_t firststsensepr;
 		bool_t firststsenseprvalpr;
-			/* sense of first subtree arg
+			/*
+			 * sense of first subtree arg
 			 */
 		ix_t stpgcnt;
-			/* how many pages following the header page are reserved
+			/*
+			 * how many pages following the header page are reserved
 			 * for the subtree descriptors
 			 */
 		bool_t restoredmpr;
-			/* restore DMAPI event settings
+			/*
+			 * restore DMAPI event settings
 			 */
 		bool_t restoreextattrpr;
-			/* restore extended attributes
+			/*
+			 * restore extended attributes
 			 */
 
 		ix_t parrestcnt;
-			/* Count of partialy restored files.  Used to speed
+			/*
+			 * Count of partialy restored files.  Used to speed
 			 * up searches in parrest.
 			 */
 
 		partial_rest_t parrest[STREAM_SIMMAX * 2 - 2];
-			/* record of bytes restored to partially restored files.
+			/*
+			 * record of bytes restored to partially restored files.
 			 * Max possible is two per stream except the first
 			 * drive will never finish another drives file and the
 			 * last drive will never leave a file for another to
@@ -498,11 +583,13 @@ struct pers {
 			 */
 	} a;
 
-	/* session state.
+	/*
+	 * session state.
 	 */
 	struct {
 		bool_t valpr;
-			/* until this is true, a resume will ignore (and bzero)
+			/*
+			 * until this is true, a resume will ignore (and bzero)
 			 * this structure. validate just prior to applying
 			 * the directory dump, and after all fields marked (A2)
 			 * are correct. invalidate as soon as the session is
@@ -511,163 +598,206 @@ struct pers {
 			 * initialized prior to setting this.
 			 */
 		time32_t accumtime;
-			/* for measuring elapsed time of restore
+			/*
+			 * for measuring elapsed time of restore
 			 */
 		uuid_t dumpid;
-			/* id of dump currently being applied
+			/*
+			 * id of dump currently being applied
 			 */
 		label_t dumplab;
-			/* label of the dump being applied (A2)
+			/*
+			 * label of the dump being applied (A2)
 			 */
 		time32_t begintime;
-			/* set when session begun and each time resumed
+			/*
+			 * set when session begun and each time resumed
 			 */
 		bool_t stat_valpr;
-			/* the following stats are not valid until the
+			/*
+			 * the following stats are not valid until the
 			 * first media file header has been read.
 			 */
 		uint64_t stat_inocnt;
-			/* number of non-dir inos to restore during session
+			/*
+			 * number of non-dir inos to restore during session
 			 */
 		uint64_t stat_inodone;
-			/* number of non-dir inos restored so far
+			/*
+			 * number of non-dir inos restored so far
 			 */
 		off64_t stat_datacnt;
-			/* bytes of ordinary files to restore during session
+			/*
+			 * bytes of ordinary files to restore during session
 			 */
 		off64_t stat_datadone;
-			/* bytes of ordinary files restored so far
+			/*
+			 * bytes of ordinary files restored so far
 			 */
 		ix_t descpgcnt;
-			/* number of pages mapped for pers. media descriptors
+			/*
+			 * number of pages mapped for pers. media descriptors
 			 */
 		dh_t descfreeh;
-			/* linked list of free media descriptor alloc objs (A2)
+			/*
+			 * linked list of free media descriptor alloc objs (A2)
 			 */
 		dh_t strmheadh;
-			/* head of singly-linked list of stream descriptors (A2)
+			/*
+			 * head of singly-linked list of stream descriptors (A2)
 			 */
 		bool_t fullinvpr;
-			/* have discovered and incorporated a full inventory
+			/*
+			 * have discovered and incorporated a full inventory
 			 * description into pers. may come from online or a
 			 * inventory media file.
 			 */
 		bool_t marknorefdonepr;
-			/* have marked tree nodes as unreferenced by directory
+			/*
+			 * have marked tree nodes as unreferenced by directory
 			 * entries, and nulled  dirattr handles.
 			 */
 		bool_t dirdonepr;
-			/* have applied all directories from a dirdump.
+			/*
+			 * have applied all directories from a dirdump.
 			 */
 		bool_t adjrefdonepr;
-			/* have adjusted marking of nodes no longer referenced
+			/*
+			 * have adjusted marking of nodes no longer referenced
 			 * by directory entries.
 			 */
 		bool_t inomapsanitizedonepr;
-			/* the inomap needs to b sanitized prior to subtree
+			/*
+			 * the inomap needs to b sanitized prior to subtree
 			 * or interactive selections
 			 */
 		bool_t stdonepr;
-			/* have applied subtree selections
+			/*
+			 * have applied subtree selections
 			 */
 		bool_t interdonepr;
-			/* have completed interactive subtree dialog
+			/*
+			 * have completed interactive subtree dialog
 			 */
 		bool_t treepostdonepr;
-			/* all of the above treep ost-processing steps have
+			/*
+			 * all of the above treep ost-processing steps have
 			 * been completed.
 			 */
 			/*
 			 * nondir restore done here
 			 */
 		bool_t dirattrdonepr;
-			/* directory attributes have been restored and
+			/*
+			 * directory attributes have been restored and
 			 * directory attributes registry has been deleted
 			 */
 		bool_t orphdeltriedpr;
-			/* removed (or tried to remove) orphanage
+			/*
+			 * removed (or tried to remove) orphanage
 			 */
 		bool_t inomapdelpr;
-			/* deleted session ino map
+			/*
+			 * deleted session ino map
 			 */
 	} s;
 };
 
 typedef struct pers pers_t;
 
-/* transient state. re-generated during each restore session
+/*
+ * transient state. re-generated during each restore session
  */
 
 struct tran {
 	time32_t t_starttime;
-		/* for measuring elapsed time of restore session
+		/*
+		 * for measuring elapsed time of restore session
 		 */
 	size64_t t_dircnt;
 	size64_t t_dirdonecnt;
 	size64_t t_direntcnt;
-		/* for displaying stats on directory reconstruction
+		/*
+		 * for displaying stats on directory reconstruction
 		 */
 	size64_t t_vmsz;
-		/* how much vm may be used. recorded here from main,
+		/*
+		 * how much vm may be used. recorded here from main,
 		 * passed to tree_init() once we have a valid media
 		 * file header
 		 */
 	bool_t t_toconlypr;
-		/* just display table of contents; don't restore files
+		/*
+		 * just display table of contents; don't restore files
 		 */
 	bool_t t_noinvupdatepr;
-		/* true if inventory is NOT to be updated when on-media
+		/*
+		 * true if inventory is NOT to be updated when on-media
 		 * inventory encountered.
 		 */
 	bool_t t_dumpidknwnpr;
-		/* determined during initialization; if false, set during
+		/*
+		 * determined during initialization; if false, set during
 		 * per-stream init
 		 */
 	bool_t t_dirattrinitdonepr;
 	bool_t t_namreginitdonepr;
 	bool_t t_treeinitdonepr;
-		/* determinied during initialization, used during
+		/*
+		 * determinied during initialization, used during
 		 * per-stream restore
 		 */
 	uuid_t t_reqdumpid;
 	bool_t t_reqdumpidvalpr;
-		/* uuid of the dump as requested on cmd line
+		/*
+		 * uuid of the dump as requested on cmd line
 		 */
 	char * t_reqdumplab;
 	bool_t t_reqdumplabvalpr;
-		/* label of the dump as requested on cmd line
+		/*
+		 * label of the dump as requested on cmd line
 		 */
 	char *t_hkdir;
-		/* absolute pathname of housekeeping directory
+		/*
+		 * absolute pathname of housekeeping directory
 		 */
 	int t_persfd;
-		/* file descriptor of the persistent state file
+		/*
+		 * file descriptor of the persistent state file
 		 */
 	size64_t t_dirdumps;
-		/* bitset of streams which contain a directory dump
+		/*
+		 * bitset of streams which contain a directory dump
 		 */
 	bool_t t_truncategenpr;
-		/* force use of truncated generation numbers
+		/*
+		 * force use of truncated generation numbers
 		 */
 	sync_t t_sync1;
-		/* to single-thread attempt to validate command line
+		/*
+		 * to single-thread attempt to validate command line
 		 * selection of dump with online inventory
 		 */
 	sync_t t_sync2;
-		/* to single-thread dump selection by media scan
+		/*
+		 * to single-thread dump selection by media scan
 		 */
 	sync_t t_sync3;
-		/* to single-thread attempt to apply dirdump to tree
+		/*
+		 * to single-thread attempt to apply dirdump to tree
 		 */
 	sync_t t_sync4;
-		/* to single-thread attempt to do tree post-processing
+		/*
+		 * to single-thread attempt to do tree post-processing
 		 * prior to non-directory restore
 		 */
 	sync_t t_sync5;
-		/* to single-thread cleanup after applying non-dir restore
+		/*
+		 * to single-thread cleanup after applying non-dir restore
 		 */
 	qlockh_t t_pilockh;
-		/* to establish critical regions while updating pers
+		/*
+		 * to establish critical regions while updating pers
 		 * inventory
 		 */
 };
@@ -932,12 +1062,14 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	int rval;
 	bool_t fullpr;
 
-	/* Calculate the size needed for the persistent inventory
+	/*
+	 * Calculate the size needed for the persistent inventory
 	 */
 	for (perssz = pgsz; perssz < sizeof(pers_t); perssz += pgsz)
 		;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(sizeof(pers_desc_t) <= PERS_DESCSZ);
 	assert(PERS_DESCSZ <= pgsz);
@@ -952,24 +1084,29 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	      "sizeof(pers_desc_t) == %d, pgsz == %d, perssz == %d \n",
 	      sizeof(pers_desc_t), pgsz, perssz);
 
-	/* allocate transient state
+	/*
+	 * allocate transient state
 	 */
 	tranp = (tran_t *)calloc(1, sizeof(tran_t));
 	assert(tranp);
 
-	/* allocate a qlock for establishing pi critical regions
+	/*
+	 * allocate a qlock for establishing pi critical regions
 	 */
 	tranp->t_pilockh = qlock_alloc(QLOCK_ORD_PI);
 
-	/* record vmsz; will be used later to init tree abstraction
+	/*
+	 * record vmsz; will be used later to init tree abstraction
 	 */
 	tranp->t_vmsz = vmsz;
 
-	/* record the start time for stats display
+	/*
+	 * record the start time for stats display
 	 */
 	tranp->t_starttime = time(0);
 
-	/* get command line options
+	/*
+	 * get command line options
 	 */
 	cumpr = BOOL_FALSE;
 	resumepr = BOOL_FALSE;
@@ -1213,7 +1350,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		}
 	}
 
-	/* command line option error checking
+	/*
+	 * command line option error checking
 	 */
 	if (cumpr && tranp->t_toconlypr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1232,13 +1370,15 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* assume all streams contain a directory dump. streams will remove
+	/*
+	 * assume all streams contain a directory dump. streams will remove
 	 * themselves from this bitset if they do not contain a directory dump.
 	 */
 	assert(drivecnt <= sizeof(tranp->t_dirdumps) * NBBY);
 	tranp->t_dirdumps = (1ULL << drivecnt) - 1;
 
-	/* the user may specify stdin as the restore source stream,
+	/*
+	 * the user may specify stdin as the restore source stream,
 	 * by a single dash ('-') with no option letter. This must
 	 * appear between the last lettered argument and the destination
 	 * directory pathname.
@@ -1247,7 +1387,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		optind++;
 	}
 
-	/* the last argument must be the destination directory. not
+	/*
+	 * the last argument must be the destination directory. not
 	 * required if table-of-contents display, or if a resumed restore
 	 * or a delta restore.
 	 */
@@ -1305,7 +1446,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		dstdir = ".";
 	}
 
-	/* generate a full pathname for the housekeeping dir.
+	/*
+	 * generate a full pathname for the housekeeping dir.
 	 * the housekeeping dir will by default be placed in the
 	 * destination directory, unless this is a toc, in which case
 	 * it will be placed in the current directory. in either case, an
@@ -1335,7 +1477,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	}
 	tranp->t_hkdir = open_pathalloc(tranp->t_hkdir, hkdirname, pid);
 
-	/* if this is a table-of-contents only restore, register an
+	/*
+	 * if this is a table-of-contents only restore, register an
 	 * exit handler to get rid of the housekeeping directory and
 	 * its contents. NOTE: needs several tran fields initialized!
 	 */
@@ -1343,7 +1486,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		atexit(toconly_cleanup);
 	}
 
-	/* create housekeeping dir if not present
+	/*
+	 * create housekeeping dir if not present
 	 */
 	rval = mkdir(tranp->t_hkdir, S_IRWXU);
 	if (rval && errno != EEXIST) {
@@ -1354,12 +1498,14 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* build a full pathname to pers. state file
+	/*
+	 * build a full pathname to pers. state file
 	 */
 	assert(! perspath);
 	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
 
-	/* open, creating if non-existent
+	/*
+	 * open, creating if non-existent
 	 */
 	tranp->t_persfd = open(perspath,
 				O_CREAT | O_RDWR,
@@ -1372,7 +1518,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* temporarily mmap just the header, and validate the command line
+	/*
+	 * temporarily mmap just the header, and validate the command line
 	 * arguments. three cases: no dumps applied so far, or one or more
 	 * dumps applied completely, or restore session was interrupted
 	 */
@@ -1386,17 +1533,20 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* but first setup or verify the on-disk format information
+	/*
+	 * but first setup or verify the on-disk format information
 	 */
 	if (! persp->a.valpr) {
-		/* this is the first restore session
+		/*
+		 * this is the first restore session
 		 */
 		persp->v.housekeeping_magic = HOUSEKEEPING_MAGIC;
 		persp->v.housekeeping_version = HOUSEKEEPING_VERSION;
 		persp->v.pagesize = pgsz;
 
 	} else {
-		/* cumulative or resuming a restore, verify the header
+		/*
+		 * cumulative or resuming a restore, verify the header
 		 */
 		if (persp->v.housekeeping_magic != HOUSEKEEPING_MAGIC) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1610,11 +1760,13 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		}
 	}
 
-	/* force owner option if root
+	/*
+	 * force owner option if root
 	 */
 	ownerpr = (geteuid() == 0) ? BOOL_TRUE : ownerpr;
 
-	/* force completion of interrupted restore if asked to do so
+	/*
+	 * force completion of interrupted restore if asked to do so
 	 */
 	if (sesscpltpr) {
 		char *path1;
@@ -1649,7 +1801,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 			return BOOL_FALSE;
 		}
 
-		/* This is only a full restore if we're doing a level
+		/*
+		 * This is only a full restore if we're doing a level
 		 * 0 restore.
 		 */
 		if (persp->a.dumpcnt == 0) {
@@ -1682,7 +1835,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		}
 	}
 
-	/* for the three cases, calculate old and new mapping params
+	/*
+	 * for the three cases, calculate old and new mapping params
 	 * and wipe partial state
 	 */
 	if (! persp->a.valpr) {
@@ -1707,7 +1861,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		persp->s.begintime = time(0);
 	}
 
-	/* unmap temp mapping of hdr, truncate, and remap hdr/subtrees
+	/*
+	 * unmap temp mapping of hdr, truncate, and remap hdr/subtrees
 	 */
 	rval = munmap((void *)persp, perssz);
 	assert(! rval);
@@ -1728,7 +1883,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* if first restore session, record cmd line args and subtrees
+	/*
+	 * if first restore session, record cmd line args and subtrees
 	 * and start time.
 	 */
 	if (! persp->a.valpr) {
@@ -1795,7 +1951,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		assert(stcnt == 0);
 	}
 
-	/* initialize the local extattr abstraction. must be done even if
+	/*
+	 * initialize the local extattr abstraction. must be done even if
 	 * we don't intend to restore extended attributes
 	 */
 	ok = extattr_init(drivecnt);
@@ -1803,7 +1960,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* effectively initialize libhandle on this filesystem by
+	/*
+	 * effectively initialize libhandle on this filesystem by
 	 * allocating a file system handle. this needs to be done
 	 * before any open_by_handle() calls (and possibly other
 	 * libhandle calls).
@@ -1824,7 +1982,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		free_handle(fshanp, fshlen);
 	}
 
-	/* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
+	/*
+	 * map in pers. inv. descriptors, if any. NOTE: this ptr is to be
 	 * referenced ONLY via the macros provided; the descriptors will be
 	 * occasionally remapped, causing the ptr to change.
 	 */
@@ -1848,7 +2007,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		pi_preclean();
 	}
 
-	/* if resuming an interrupted restore, indicate we know the id
+	/*
+	 * if resuming an interrupted restore, indicate we know the id
 	 * of the dump session being restored. otherwise, it will be determined
 	 * during coordination of per-drive threads.
 	 */
@@ -1857,7 +2017,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		tranp->t_dumpidknwnpr = BOOL_TRUE;
 	}
 
-	/* sync up with the directory attributes registry.
+	/*
+	 * sync up with the directory attributes registry.
 	 * starts fresh with each dump session restored.
 	 * determine if full init needed instead.
 	 */
@@ -1869,7 +2030,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		tranp->t_dirattrinitdonepr = BOOL_TRUE;
 	}
 
-	/* sync up with the name registry. created by the
+	/*
+	 * sync up with the name registry. created by the
 	 * first session, retained by subsequent sessions.
 	 * determine if full init needed instead.
 	 */
@@ -1881,7 +2043,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		tranp->t_namreginitdonepr = BOOL_TRUE;
 	}
 
-	/* sync up with the inomap abstraction. created anew with each fresh
+	/*
+	 * sync up with the inomap abstraction. created anew with each fresh
 	 * restore session, but persistent after tree updated with dirdump.
 	 * determine if full init needed instead.
 	 */
@@ -1890,13 +2053,15 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		return BOOL_FALSE;
 	}
 
-	/* sync up with the tree abstraction. created by the
+	/*
+	 * sync up with the tree abstraction. created by the
 	 * first session, retained by subsequent sessions.
 	 * don't call tree_init() from here; can only be called
 	 * when a valid media file header is at hand.
 	 */
 	if (persp->a.valpr) {
-		/* This is only a full restore if we're doing a level
+		/*
+		 * This is only a full restore if we're doing a level
 		 * 0 restore.
 		 */
 		if (persp->a.dumpcnt == 0) {
@@ -1916,7 +2081,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		tranp->t_treeinitdonepr = BOOL_TRUE;
 	}
 
-	/* set media change flags to FALSE;
+	/*
+	 * set media change flags to FALSE;
 	 */
 	{
 		ix_t ix;
@@ -1933,7 +2099,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	return BOOL_TRUE;
 }
 
-/* stream thread entry point - returns exit code
+/*
+ * stream thread entry point - returns exit code
  */
 int
 content_stream_restore(ix_t thrdix)
@@ -1956,14 +2123,16 @@ content_stream_restore(ix_t thrdix)
 	bool_t ok;
 	int rval;
 
-	/* allocate two path buffers
+	/*
+	 * allocate two path buffers
 	 */
 	path1 = (char *)calloc(1, 2 * MAXPATHLEN);
 	assert(path1);
 	path2 = (char *)calloc(1, 2 * MAXPATHLEN);
 	assert(path2);
 
-	/* set the current directory to dstdir. the tree abstraction
+	/*
+	 * set the current directory to dstdir. the tree abstraction
 	 * depends on the current directory being the root of the
 	 * destination file system.
 	 */
@@ -1976,12 +2145,14 @@ content_stream_restore(ix_t thrdix)
 		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 
-	/* set my file creation mask to zero, to avoid modifying the
+	/*
+	 * set my file creation mask to zero, to avoid modifying the
 	 * dumped mode bits
 	 */
 	(void)umask(0);
 
-	/* initialize the Media abstraction
+	/*
+	 * initialize the Media abstraction
 	 */
 	Mediap = Media_create(thrdix);
 
@@ -1999,7 +2170,8 @@ content_stream_restore(ix_t thrdix)
 	strctxp->sc_fd = -1;
 	Mediap->M_drivep->d_strmcontextp = (void *)strctxp;
 
-	/* if we don't know the dump session id to restore,
+	/*
+	 * if we don't know the dump session id to restore,
 	 * first see if command line options can be validated
 	 * against the online inventory to identify it. only
 	 * one stream needs to do this; the others just wait.
@@ -2028,7 +2200,8 @@ content_stream_restore(ix_t thrdix)
 		mlog(MLOG_DEBUG,
 		      "checking and validating command line dump id/label\n");
 		ok = Inv_validate_cmdline();
-		    /* side-effect - searches for and incorporates online inv
+		    /*
+		     * side-effect - searches for and incorporates online inv
 		     * into pi, and makes persp->s.dumpid valid.
 		     */
 		if (ok == BOOL_ERROR) {
@@ -2038,7 +2211,8 @@ content_stream_restore(ix_t thrdix)
 		tranp->t_sync1 = SYNC_DONE;
 	}
 
-	/* if we still don't know the session to restore, search the
+	/*
+	 * if we still don't know the session to restore, search the
 	 * media for a match either to the command line arguments or
 	 * until the operator selects a media file from the desired
 	 * dump.
@@ -2201,7 +2375,8 @@ content_stream_restore(ix_t thrdix)
 			     sizeof(persp->s.dumplab));
 		sessp = 0;
 
-		/* don't look at the online inventory if the input is piped
+		/*
+		 * don't look at the online inventory if the input is piped
 		 */
 		if (! drivep->d_isnamedpipepr
 		     &&
@@ -2222,7 +2397,8 @@ content_stream_restore(ix_t thrdix)
 				    mrhdrp,
 				    scrhdrp,
 				    drivep);
-			/* done here because Media_mfile_next doesn't know
+			/*
+			 * done here because Media_mfile_next doesn't know
 			 * if this is a match
 			 */
 		if (fileh == DH_NULL) {
@@ -2234,7 +2410,8 @@ content_stream_restore(ix_t thrdix)
 		tranp->t_sync2 = SYNC_DONE;
 	}
 
-	/* all drives coordinate in attempt to apply session dir dump.
+	/*
+	 * all drives coordinate in attempt to apply session dir dump.
 	 * only one actually completes.
 	 */
 	if (persp->s.dirdonepr) {
@@ -2306,7 +2483,8 @@ content_stream_restore(ix_t thrdix)
 			continue;
 		}
 		if (!(scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP)) {
-			/* if no streams have a directory dump, issue a
+			/*
+			 * if no streams have a directory dump, issue a
 			 * message and exit. first set SYNC_BUSY to prevent
 			 * other threads from coming through here and issuing
 			 * the same message.
@@ -2404,7 +2582,8 @@ content_stream_restore(ix_t thrdix)
 			}
 		}
 
-		/* commit the session and accumulative state
+		/*
+		 * commit the session and accumulative state
 		 */
 		persp->s.valpr = BOOL_TRUE;
 		persp->a.valpr = BOOL_TRUE;
@@ -2438,7 +2617,8 @@ content_stream_restore(ix_t thrdix)
 		}
 	}
 
-	/* now let one thread do all tree post-processing prior to
+	/*
+	 * now let one thread do all tree post-processing prior to
 	 * non-dir restore
 	 */
 	if (persp->s.treepostdonepr) {
@@ -2499,7 +2679,8 @@ content_stream_restore(ix_t thrdix)
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
-		/* now that we have a tree and inomap, scan the
+		/*
+		 * now that we have a tree and inomap, scan the
 		 * pi to see what media files can be skipped.
 		 * this func has cancer: too many flags and
 		 * side-effects!
@@ -2517,12 +2698,14 @@ content_stream_restore(ix_t thrdix)
 		}
 		}
 
-		/* release exclusion
+		/*
+		 * release exclusion
 		 */
 		tranp->t_sync4 = SYNC_DONE;
 	}
 
-	/* now all are free to do concurrent non-dir restore!
+	/*
+	 * now all are free to do concurrent non-dir restore!
 	 * apply media files until there are no more, or we are interrupted
 	 */
 	for (;;) {
@@ -2600,7 +2783,8 @@ content_stream_restore(ix_t thrdix)
 		}
 	}
 
-	/* finally, choose one thread to do final processing
+	/*
+	 * finally, choose one thread to do final processing
 	 * and cleanup. the winner waits, the losers all exit.
 	 * once the losers exit, the winner can perform cleanup.
 	 */
@@ -2633,7 +2817,8 @@ content_stream_restore(ix_t thrdix)
 	return mlog_exit(rval, rv);
 }
 
-/* called after all threads have exited. scans state to decide
+/*
+ * called after all threads have exited. scans state to decide
  * if interrupted or not.
  */
 bool_t
@@ -2703,7 +2888,8 @@ content_complete(void)
 		      GETOPT_RESUME);
 	}
 
-	/* accumulate total elapsed time
+	/*
+	 * accumulate total elapsed time
 	 */
 	if (persp) {
 		persp->s.accumtime = elapsed;
@@ -2734,7 +2920,8 @@ content_statline(char **linespp[])
 	struct tm *tmp;
 	ix_t i;
 
-	/* build and supply the line array
+	/*
+	 * build and supply the line array
 	 */
 	for (i = 0; i < 1; i++) {
 		statline[i] = &statlinebuf[i][0];
@@ -2745,13 +2932,15 @@ content_statline(char **linespp[])
 		return 0;
 	}
 
-	/* calculate the elapsed time
+	/*
+	 * calculate the elapsed time
 	 */
 	elapsed = persp->s.accumtime
 		  +
 		  (time(0) - tranp->t_starttime);
 
-	/* get local time
+	/*
+	 * get local time
 	 */
 	now = time(0);
 	tmp = localtime(&now);
@@ -2784,7 +2973,8 @@ content_statline(char **linespp[])
 		return 1;
 	}
 
-	/* get the accumulated totals for non-dir inos and data bytes dumped.
+	/*
+	 * get the accumulated totals for non-dir inos and data bytes dumped.
 	 * not under lock!
 	 */
 	inodone = persp->s.stat_inodone;
@@ -2792,7 +2982,8 @@ content_statline(char **linespp[])
 	inocnt = persp->s.stat_inocnt;
 	datacnt = persp->s.stat_datacnt;
 
-	/* calculate percentage of data dumped
+	/*
+	 * calculate percentage of data dumped
 	 */
 	if (datacnt) {
 		percent = (double)datadone
@@ -2806,7 +2997,8 @@ content_statline(char **linespp[])
 		percent = 100.0;
 	}
 
-	/* format the status line in a local static buffer (non-re-entrant!)
+	/*
+	 * format the status line in a local static buffer (non-re-entrant!)
 	 */
 	sprintf(statline[0], _(
 		 "status at %02d:%02d:%02d: %llu/%llu files restored, "
@@ -2821,7 +3013,8 @@ content_statline(char **linespp[])
 		 elapsed);
 	assert(strlen(statline[0]) < STATLINESZ);
 
-	/* return buffer to caller
+	/*
+	 * return buffer to caller
 	 */
 	return 1;
 }
@@ -2853,7 +3046,8 @@ content_showremainingobjects(void)
 	}
 }
 
-/* dlog_begin already called; this is a second-level dialog.
+/*
+ * dlog_begin already called; this is a second-level dialog.
  * prompt for each thread currently waiting for confirmation,
  * as well as an info prompt.
  */
@@ -2969,7 +3163,8 @@ content_mediachange_query(void)
 
 /* definition of locally defined static functions ****************************/
 
-/* does all pre-processing leading up to applying the dirdump,
+/*
+ * does all pre-processing leading up to applying the dirdump,
  * then applies the dirdump. updates pers progress flags along the way.
  * does NOT do any post-processing!
  */
@@ -3043,14 +3238,16 @@ applydirdump(drive_t *drivep,
 		for (;;) {
 			nh_t dirh;
 
-			/* read the file header
+			/*
+			 * read the file header
 			 */
 			rv = read_filehdr(drivep, fhdrp, fhcs);
 			if (rv) {
 				return rv;
 			}
 
-			/* if this is a null file hdr, we're done
+			/*
+			 * if this is a null file hdr, we're done
 			 * reading dirs, and there are no nondirs.
 			 * done.
 			 */
@@ -3058,20 +3255,23 @@ applydirdump(drive_t *drivep,
 				break;
 			}
 
-			/* if its not a directory, must be the
+			/*
+			 * if its not a directory, must be the
 			 * first non-dir file. done.
 			 */
 			if ((fhdrp->fh_stat.bs_mode & S_IFMT) != S_IFDIR) {
 				break;
 			}
 
-			/* if stop requested bail out gracefully
+			/*
+			 * if stop requested bail out gracefully
 			 */
 			if (cldmgr_stop_requested()) {
 				return RV_INTR;
 			}
 
-			/* if in a pipeline, call preemptchk() to
+			/*
+			 * if in a pipeline, call preemptchk() to
 			 * print status reports
 			 */
 			if (pipeline)
@@ -3081,7 +3281,8 @@ applydirdump(drive_t *drivep,
 				preemptchk();
 			}
 
-			/* may be an extended attributes file hdr
+			/*
+			 * may be an extended attributes file hdr
 			 */
 			if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
 				rv = restore_extattr(drivep,
@@ -3097,7 +3298,8 @@ applydirdump(drive_t *drivep,
 				continue;
 			}
 
-			/* add the directory to the tree. save the
+			/*
+			 * add the directory to the tree. save the
 			 * returned tree node id, to associate with
 			 * the directory entries. get the dirattr handle,
 			 * so that any extattr following will be associated
@@ -3108,7 +3310,8 @@ applydirdump(drive_t *drivep,
 			if (dirh == NH_NULL)
 			    return RV_ERROR;
 
-			/* read the directory entries, and populate the
+			/*
+			 * read the directory entries, and populate the
 			 * tree with them. we can tell when we are done
 			 * by looking for a null dirent.
 			 */
@@ -3125,7 +3328,8 @@ applydirdump(drive_t *drivep,
 					return rv;
 				}
 
-				/* if null, we're done with this dir.
+				/*
+				 * if null, we're done with this dir.
 				 * break out of this inner loop and
 				 * move on th the next dir.
 				 */
@@ -3135,7 +3339,8 @@ applydirdump(drive_t *drivep,
 				namelen = strlen(dhdrp->dh_name);
 				assert(namelen <= NAME_MAX);
 
-				/* add this dirent to the tree.
+				/*
+				 * add this dirent to the tree.
 				 */
 				rv = tree_addent(dirh,
 					     dhdrp->dh_ino,
@@ -3170,7 +3375,8 @@ applydirdump(drive_t *drivep,
 	return RV_OK;
 }
 
-/* like applydirdump, but just eats up the inomap/dirdump portion of the
+/*
+ * like applydirdump, but just eats up the inomap/dirdump portion of the
  * dump, doesn't use it. the first non-dir filehdr_t is copied into supplied
  * buffer. returns integer error code from drive ops used.
  */
@@ -3220,14 +3426,16 @@ eatdirdump(drive_t *drivep,
 	mlog(MLOG_DEBUG,
 	      "discarding directories \n");
 	for (;;) {
-		/* read the file header
+		/*
+		 * read the file header
 		 */
 		rv = read_filehdr(drivep, fhdrp, fhcs);
 		if (rv) {
 			return rv;
 		}
 
-		/* if this is a null file hdr, we're done
+		/*
+		 * if this is a null file hdr, we're done
 		 * reading dirs, and there are no nondirs.
 		 * done.
 		 */
@@ -3235,20 +3443,23 @@ eatdirdump(drive_t *drivep,
 			break;
 		}
 
-		/* if its not a directory, must be the
+		/*
+		 * if its not a directory, must be the
 		 * first non-dir file. done.
 		 */
 		if ((fhdrp->fh_stat.bs_mode & S_IFMT) != S_IFDIR) {
 			break;
 		}
 
-		/* if stop requested bail out gracefully
+		/*
+		 * if stop requested bail out gracefully
 		 */
 		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
-		/* may be an extended attributes file hdr
+		/*
+		 * may be an extended attributes file hdr
 		 */
 		if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
 			rv = restore_extattr(drivep,
@@ -3264,7 +3475,8 @@ eatdirdump(drive_t *drivep,
 			continue;
 		}
 
-		/* read the directory entries.
+		/*
+		 * read the directory entries.
 		 * we can tell when we are done
 		 * by looking for a null dirent.
 		 */
@@ -3282,7 +3494,8 @@ eatdirdump(drive_t *drivep,
 				return rv;
 			}
 
-			/* if null, we're done with this dir.
+			/*
+			 * if null, we're done with this dir.
 			 * break out of this inner loop and
 			 * move on th the next dir.
 			 */
@@ -3297,7 +3510,8 @@ eatdirdump(drive_t *drivep,
 	return RV_OK;
 }
 
-/* does all post-processing of the tree required prior to restoral of
+/*
+ * does all post-processing of the tree required prior to restoral of
  * the non-directory portion of the dump. only one thread at a time,
  * so no locking needed. since the steps are interdependent, loops
  * until no point in doing so.
@@ -3308,7 +3522,8 @@ treepost(char *path1, char *path2)
 	bool_t ok;
 
 #ifdef TREE_CHK
-	/* first scan the tree for corruption
+	/*
+	 * first scan the tree for corruption
 	 */
 	mlog(MLOG_DEBUG | MLOG_TREE,
 	      "checking tree for consistency\n");
@@ -3317,7 +3532,8 @@ treepost(char *path1, char *path2)
 	}
 #endif /* TREE_CHK */
 
-	/* adjust ref flags based on what dirs were dumped
+	/*
+	 * adjust ref flags based on what dirs were dumped
 	 */
 	if (! persp->s.adjrefdonepr) {
 		mlog(MLOG_DEBUG | MLOG_TREE,
@@ -3329,7 +3545,8 @@ treepost(char *path1, char *path2)
 		persp->s.adjrefdonepr = BOOL_TRUE;
 	}
 
-	/* if a subtree or interactive restore, sanitize the inomap
+	/*
+	 * if a subtree or interactive restore, sanitize the inomap
 	 * so only inos selected by subtree or interactive cmds will
 	 * be present in inomap.
 	 */
@@ -3344,7 +3561,8 @@ treepost(char *path1, char *path2)
 		persp->s.inomapsanitizedonepr = BOOL_TRUE;
 	}
 
-	/* apply subtree selections
+	/*
+	 * apply subtree selections
 	 */
 	if (! persp->s.stdonepr) {
 		ix_t stix;
@@ -3353,7 +3571,8 @@ treepost(char *path1, char *path2)
 		mlog(MLOG_DEBUG | MLOG_TREE,
 		      "applying subtree selections\n");
 
-		/* if first subtree selection is inclusive in sense,
+		/*
+		 * if first subtree selection is inclusive in sense,
 		 * first mark the entire tree as unselected. otherwise,
 		 * select all (no subtree selections or first was excluding).
 		 */
@@ -3371,7 +3590,8 @@ treepost(char *path1, char *path2)
 			tree_markallsubtree(BOOL_TRUE);
 		}
 
-		/* now apply all subtree commands from command line
+		/*
+		 * now apply all subtree commands from command line
 		 */
 		for (stix = 0,
 		      stdescp = (stdesc_t *)((char *)persp + perssz)
@@ -3394,7 +3614,8 @@ treepost(char *path1, char *path2)
 		persp->s.stdonepr = BOOL_TRUE;
 	}
 
-	/* next engage interactive subtree selection
+	/*
+	 * next engage interactive subtree selection
 	 */
 	if (! persp->s.interdonepr) {
 		if (persp->a.interpr) {
@@ -3438,7 +3659,8 @@ applynondirdump(drive_t *drivep,
 	egrp_t next_egrp;
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 
-	/* determine if file header and/or extent heade checksums present
+	/*
+	 * determine if file header and/or extent heade checksums present
 	 */
 	fhcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM)
 	       ?
@@ -3456,12 +3678,14 @@ applynondirdump(drive_t *drivep,
 	       :
 	       BOOL_FALSE;
 
-	/* determine the first and next egrps needed from this media file.
+	/*
+	 * determine the first and next egrps needed from this media file.
 	 * used to decide if stats should be updated
 	 */
 	pi_bracketneededegrps(fileh, &first_egrp, &next_egrp);
 
-	/* initialize the stream context
+	/*
+	 * initialize the stream context
 	 */
 	memset(&strctxp->sc_bstat, 0, sizeof(bstat_t));
 	strctxp->sc_path[0] = '\0';
@@ -3476,14 +3700,16 @@ applynondirdump(drive_t *drivep,
 		bool_t resyncpr = BOOL_FALSE;
 		int rval;
 
-		/* if a null file header, break
+		/*
+		 * if a null file header, break
 		 */
 		if (fhdrp->fh_flags & FILEHDR_FLAGS_NULL) {
 			rv = RV_OK;
 			goto applynondirdump_out;
 		}
 
-		/* if working on a different file than we were previously,
+		/*
+		 * if working on a different file than we were previously,
 		 * complete the old one and begin the new one.
 		 */
 		if (bstatp->bs_ino != strctxp->sc_bstat.bs_ino) {
@@ -3538,7 +3764,8 @@ applynondirdump(drive_t *drivep,
 			goto applynondirdump_out;
 		}
 
-		/* update stats if appropriate
+		/*
+		 * update stats if appropriate
 		 */
 		if (((bstatp->bs_mode & S_IFMT) == S_IFREG)
 		     &&
@@ -3564,11 +3791,13 @@ applynondirdump(drive_t *drivep,
 		}
 
 		do {
-			/* get a mark for the next read, in case we restart here
+			/*
+			 * get a mark for the next read, in case we restart here
 			 */
 			(*dop->do_get_mark)(drivep, &drivemark);
 
-			/* read the file header.
+			/*
+			 * read the file header.
 			 */
 			rv = read_filehdr(drivep, fhdrp, fhcs);
 			switch (rv) {
@@ -3602,7 +3831,8 @@ applynondirdump(drive_t *drivep,
 			}
 		} while (resyncpr);
 
-		/* checkpoint into persistent state if not a null file hdr
+		/*
+		 * checkpoint into persistent state if not a null file hdr
 		 */
 		if (! (fhdrp->fh_flags & FILEHDR_FLAGS_NULL)) {
 			pi_checkpoint(fileh,
@@ -3611,7 +3841,8 @@ applynondirdump(drive_t *drivep,
 				       fhdrp->fh_offset);
 		}
 
-		/* if in a pipeline, call preemptchk() to
+		/*
+		 * if in a pipeline, call preemptchk() to
 		 * print status reports
 		 */
 		if (pipeline)
@@ -3624,7 +3855,8 @@ applynondirdump(drive_t *drivep,
 
 applynondirdump_out:
 
-	/* We've hit the end of this media file or encountered corruption.
+	/*
+	 * We've hit the end of this media file or encountered corruption.
 	 * In either case, we may not be back to complete the metadata for
 	 * this file, so attempt to complete it now.
 	 */
@@ -3641,7 +3873,8 @@ finalize(char *path1, char *path2)
 
 	if (! tranp->t_toconlypr) {
 
-		/* restore directory attributes
+		/*
+		 * restore directory attributes
 		 */
 		if (! persp->s.dirattrdonepr) {;
 			ok = tree_setattr(path1);
@@ -3651,7 +3884,8 @@ finalize(char *path1, char *path2)
 			persp->s.dirattrdonepr = BOOL_TRUE;
 		}
 
-		/* remove orphanage if empty
+		/*
+		 * remove orphanage if empty
 		 */
 		if (! persp->s.orphdeltriedpr) {;
 			ok = tree_delorph();
@@ -3661,7 +3895,8 @@ finalize(char *path1, char *path2)
 			persp->s.orphdeltriedpr = BOOL_TRUE;
 		}
 
-		/* delete the persistent ino map
+		/*
+		 * delete the persistent ino map
 		 */
 		if (! persp->s.inomapdelpr) {
 			inomap_del_pers(tranp->t_hkdir);
@@ -3669,13 +3904,15 @@ finalize(char *path1, char *path2)
 		}
 	}
 
-	/* at this point, all session-only persistent state has been deleted.
+	/*
+	 * at this point, all session-only persistent state has been deleted.
 	 * if this is a cumulative restore, just update the pers cum state and
 	 * invalidate the pers session state. otherwise, invalidate the
 	 * persistent state. content_complete will remove housekeeping dir.
 	 */
 	if (persp->a.cumpr) {
-		/* following must be atomic!
+		/*
+		 * following must be atomic!
 		 */
 		persp->a.dumpcnt++;
 		uuid_copy(persp->a.lastdumpid, persp->s.dumpid);
@@ -3749,7 +3986,8 @@ wipepersstate(void)
 
 /* Inv abstraction ***********************************************************/
 
-/* attempt to validate id or label against online inventory.
+/*
+ * attempt to validate id or label against online inventory.
  * sets pers id/label and pers idvalpr etc as side-effect (does NOT set valpr!)
  */
 static bool_t
@@ -3829,7 +4067,8 @@ Media_create(ix_t thrdix)
 	return Mediap;
 }
 
-/* these calls allow the Media users to clue Media in to fine position changes
+/*
+ * these calls allow the Media users to clue Media in to fine position changes
  * within the current media file
  */
 static void
@@ -3850,7 +4089,8 @@ Media_atnondir(Media_t *Mediap)
 	Mediap->M_pos = POS_ATNONDIR;
 }
 
-/* supplies pertinent media files to the caller. if purpose is search,
+/*
+ * supplies pertinent media files to the caller. if purpose is search,
  * returns all media files. otherwise, returns only media files with the
  * dump ID. smart enough to know that if purpose was search but is now dir,
  * current media file can be returned again. same for other transitions.
@@ -3901,7 +4141,8 @@ Media_mfile_next(Media_t *Mediap,
 	      purp,
 	      Mediap->M_pos);
 
-	/* pass back hdr and drive ptrs
+	/*
+	 * pass back hdr and drive ptrs
 	 */
 	*grhdrpp =  grhdrp;
 	*drhdrpp =  drhdrp;
@@ -3910,17 +4151,20 @@ Media_mfile_next(Media_t *Mediap,
 	*scrhdrpp =  scrhdrp;
 	*drivepp = drivep;
 
-	/* if ref return for pers mfile desc supplied, pre-zero
+	/*
+	 * if ref return for pers mfile desc supplied, pre-zero
 	 */
 	if (filehp) {
 		*filehp = DH_NULL;
 	}
 
-	/* keep a close eye on the validity of fileh
+	/*
+	 * keep a close eye on the validity of fileh
 	 */
 	fileh = DH_NULL;
 
-	/* if purpose has changed, invalidate first, last, and previous indices
+	/*
+	 * if purpose has changed, invalidate first, last, and previous indices
 	 */
 	if (Mediap->M_flmfixvalpr) {
 		if (purp != Mediap->M_mfixpurp) {
@@ -3929,14 +4173,16 @@ Media_mfile_next(Media_t *Mediap,
 		}
 	}
 
-	/* use a local variable to keep track of dump sessions seen on
+	/*
+	 * use a local variable to keep track of dump sessions seen on
 	 * media. if not in search mode, each time we see a different
 	 * dump session, log a message to keep the user informed.
 	 * invalidated each time we change media or rewind.
 	 */
 	uuid_clear(prevmfiledumpid);
 
-	/* if restore is complete, return indication. be sure to end read
+	/*
+	 * if restore is complete, return indication. be sure to end read
 	 * if active.
 	 */
 	if (purp == PURP_NONDIR
@@ -3954,7 +4200,8 @@ Media_mfile_next(Media_t *Mediap,
 		return RV_NOMORE;
 	}
 
-	/* loop searching for an acceptable media file.
+	/*
+	 * loop searching for an acceptable media file.
 	 * change media as necessary.
 	 */
 	for (;;) {
@@ -3975,7 +4222,8 @@ Media_mfile_next(Media_t *Mediap,
 
 		emptypr = BOOL_FALSE;
 
-		/* check if no point in going on
+		/*
+		 * check if no point in going on
 		 */
 		if (cldmgr_stop_requested()) {
 			return RV_INTR;
@@ -3989,7 +4237,8 @@ Media_mfile_next(Media_t *Mediap,
 			return RV_NOMORE;
 		}
 
-		/* if we have a useless media object, get another one
+		/*
+		 * if we have a useless media object, get another one
 		 */
 		if (Mediap->M_pos == POS_USELESS
 		     ||
@@ -3997,7 +4246,8 @@ Media_mfile_next(Media_t *Mediap,
 			goto newmedia;
 		}
 
-		/* if the purpose if to search, and we already have
+		/*
+		 * if the purpose if to search, and we already have
 		 * a media file, that media file has already been
 		 * searched, so set pos to cause another begin read
 		 */
@@ -4011,7 +4261,8 @@ Media_mfile_next(Media_t *Mediap,
 			}
 		}
 
-		/* if already have a media file, skip the begin_read
+		/*
+		 * if already have a media file, skip the begin_read
 		 */
 		if (Mediap->M_pos == POS_ATHDR
 		     ||
@@ -4021,7 +4272,8 @@ Media_mfile_next(Media_t *Mediap,
 			goto validate;
 		}
 
-		/* see if the indices say we've seen all there is to see
+		/*
+		 * see if the indices say we've seen all there is to see
 		 */
 		if (Mediap->M_flmfixvalpr) {
 			if (Mediap->M_pos == POS_UNKN) {
@@ -4041,7 +4293,8 @@ Media_mfile_next(Media_t *Mediap,
 			}
 		}
 
-		/* if we are at the end, do a rewind, or get new media
+		/*
+		 * if we are at the end, do a rewind, or get new media
 		 * if rewinds not possible. this may take a while, so
 		 * afterwards check for interrupt or if someone else
 		 * has finished the job.
@@ -4067,7 +4320,8 @@ Media_mfile_next(Media_t *Mediap,
 			}
 		}
 
-		/* begin a new media file, and determine new position.
+		/*
+		 * begin a new media file, and determine new position.
 		 * bail if catastrophic. also, tell pi about EOD/EOM
 		 * if appropriate.
 		 */
@@ -4152,7 +4406,8 @@ Media_mfile_next(Media_t *Mediap,
 		}
 
 validate:
-		/* update the positional indices
+		/*
+		 * update the positional indices
 		 */
 		if (Mediap->M_pos == POS_ATHDR
 		     ||
@@ -4167,7 +4422,8 @@ validate:
 			Mediap->M_lmfix = mrhdrp->mh_mediafileix;
 		}
 
-		/* check for interrupt. be sure to end_read if necessary
+		/*
+		 * check for interrupt. be sure to end_read if necessary
 		 */
 		if (cldmgr_stop_requested()) {
 			if (Mediap->M_pos == POS_ATHDR
@@ -4182,14 +4438,16 @@ validate:
 			return RV_INTR;
 		}
 
-		/* check if another thread has finished job (for this purpose).
+		/*
+		 * check if another thread has finished job (for this purpose).
 		 * don't end_read, we will be back.
 		 */
 		if (donesyncp && *donesyncp == SYNC_DONE) {
 			return RV_DONE;
 		}
 
-		/* we may be done due to the actions of other threads.
+		/*
+		 * we may be done due to the actions of other threads.
 		 * if so, return indicating so
 		 */
 		if (purp == PURP_NONDIR
@@ -4198,7 +4456,8 @@ validate:
 			return RV_NOMORE;
 		}
 
-		/* if the media object is useless, go get more
+		/*
+		 * if the media object is useless, go get more
 		 */
 		if (Mediap->M_pos == POS_USELESS
 		     ||
@@ -4206,7 +4465,8 @@ validate:
 			goto newmedia;
 		}
 
-		/* if we hit the end, this is not a search, and we've
+		/*
+		 * if we hit the end, this is not a search, and we've
 		 * seen at least one media file pertaining to the dump,
 		 * ask the inventory if there is any point in examining
 		 * the beginning of the object.
@@ -4223,21 +4483,24 @@ validate:
 			goto newmedia;
 		}
 
-		/* if we hit the end, go back to the top, where
+		/*
+		 * if we hit the end, go back to the top, where
 		 * we will decide if we should rewind or get new media.
 		 */
 		if (Mediap->M_pos == POS_END) {
 			continue;
 		}
 
-		/* if the purpose is to search, return this media file
+		/*
+		 * if the purpose is to search, return this media file
 		 */
 		if (purp == PURP_SEARCH) {
 			assert(Mediap->M_pos == POS_ATHDR);
 			return RV_OK;
 		}
 
-		/* see if this media file is part of the desired dump session
+		/*
+		 * see if this media file is part of the desired dump session
 		 */
 		partofdumppr = (bool_t)(uuid_compare(persp->s.dumpid,
 						     grhdrp->gh_dumpid) == 0);
@@ -4253,7 +4516,8 @@ validate:
 			  inv_string_uuid, gh_string_uuid);
 		}
 
-		/* if media file dump id is different from the preceeding
+		/*
+		 * if media file dump id is different from the preceeding
 		 * media file, print something useful at TRACE verbosity.
 		 */
 		if (uuid_compare(prevmfiledumpid,
@@ -4279,7 +4543,8 @@ validate:
 			uuid_copy(prevmfiledumpid, grhdrp->gh_dumpid);
 		}
 
-		/* if this media file is not part of the desired dump session,
+		/*
+		 * if this media file is not part of the desired dump session,
 		 * and a preceeding media file on this object was part of the
 		 * dump, we know we have hit the end of the stream. tell the
 		 * persistent inventory.
@@ -4294,7 +4559,8 @@ validate:
 					Mediap->M_lmfix);
 		}
 
-		/* if this media file is not part of the desired dump session,
+		/*
+		 * if this media file is not part of the desired dump session,
 		 * we are doing non-dir, and the preceeding media file on this
 		 * object was part of the dump, we know we have hit the end of
 		 * the stream. check if we are done.
@@ -4314,7 +4580,8 @@ validate:
 			}
 		}
 
-		/* if this media file is not part of the desired dump session,
+		/*
+		 * if this media file is not part of the desired dump session,
 		 * and preceeding media files on this object were, decide if
 		 * we need to rewind and look at the beginning of the object.
 		 */
@@ -4336,7 +4603,8 @@ validate:
 			}
 		}
 
-		/* if this media file is not part of the desired dump session,
+		/*
+		 * if this media file is not part of the desired dump session,
 		 * and the above conditions were not met, then keep looking
 		 */
 		if (! partofdumppr) {
@@ -4346,7 +4614,8 @@ validate:
 			continue;
 		}
 
-		/* record the index within this media object of the first
+		/*
+		 * record the index within this media object of the first
 		 * media file in the dump stream
 		 */
 		if (! Mediap->M_fsfixvalpr) {
@@ -4359,7 +4628,8 @@ validate:
 			Mediap->M_fsfixvalpr = BOOL_TRUE;
 		}
 
-		/* this media file is part of the dump. add it to the
+		/*
+		 * this media file is part of the dump. add it to the
 		 * persistent inventory and get a file handle.
 		 */
 		fileh = pi_addfile(Mediap,
@@ -4381,7 +4651,8 @@ validate:
 
 		pi_note_underhead(objh, fileh);
 
-		/* if purp is nondir, we may be done.
+		/*
+		 * if purp is nondir, we may be done.
 		 */
 		if (purp == PURP_NONDIR && pi_alldone()) {
 			(*dop->do_end_read)(drivep);
@@ -4389,7 +4660,8 @@ validate:
 			return RV_NOMORE;
 		}
 
-		/* check for a wraparound
+		/*
+		 * check for a wraparound
 		 */
 		if (Mediap->M_flmfixvalpr) {
 			if (Mediap->M_fsfixvalpr
@@ -4414,7 +4686,8 @@ validate:
 			}
 		}
 
-		/* if this media file is an inventory or a terminator,
+		/*
+		 * if this media file is an inventory or a terminator,
 		 * we have hit the end of the stream. don't tell the persistent
 		 * inventory; it already knows because of a pi_addfile.
 		 * decide if any preceeding media files are useful and if so
@@ -4445,7 +4718,8 @@ validate:
 			goto newmedia;
 		}
 
-		/* if the purpose is dir, but this media file is not positioned
+		/*
+		 * if the purpose is dir, but this media file is not positioned
 		 * at the hdr or has already been tried, get another one.
 		 * use the persistent inventory to do this intelligently.
 		 */
@@ -4481,7 +4755,8 @@ validate:
 			}
 		}
 
-		/* if the purpose is dir, give it to the caller
+		/*
+		 * if the purpose is dir, give it to the caller
 		 */
 		if (purp == PURP_DIR) {
 			assert(Mediap->M_pos == POS_ATHDR);
@@ -4492,11 +4767,13 @@ validate:
 			return RV_OK;
 		}
 
-		/* if we made it this far, the purpose is NONDIR and this
+		/*
+		 * if we made it this far, the purpose is NONDIR and this
 		 * is a valid media file from the desired dump session.
 		 */
 
-		/* see if this media file contains any inodes not yet restored
+		/*
+		 * see if this media file contains any inodes not yet restored
 		 */
 		assert(fileh != DH_NULL);
 		pi_lock();
@@ -4505,7 +4782,8 @@ validate:
 		endino = pi_scanfileendino(fileh);
 		hassomepr = inomap_rst_needed(begino, endino);
 
-		/* if we have already given up on this media file or
+		/*
+		 * if we have already given up on this media file or
 		 * it doesn't contains anything not yet restored,
 		 * or it can be skipped, move on. force the done flag on,
 		 * so we don't check it again.
@@ -4546,12 +4824,14 @@ validate:
 			}
 		}
 
-		/* so the purpose is NONDIR and we like this media file.
+		/*
+		 * so the purpose is NONDIR and we like this media file.
 		 * be sure we are positioned at the beginning of the
 		 * non-dir filehdr not yet restored, and supply to caller.
 		 */
 
-		/* need to position just after the first
+		/*
+		 * need to position just after the first
 		 * non-dir filehdr_t not yet restored.
 		 * may be a problem if we are currently positioned
 		 * in the middle of the dir dump and have no
@@ -4648,7 +4928,8 @@ validate:
 		    break;
 		}
 
-		/* if error encountered during fine positioning,
+		/*
+		 * if error encountered during fine positioning,
 		 * mark file so we won't try it again
 		 */
 		if (rval) {
@@ -4657,7 +4938,8 @@ validate:
 			Mediap->M_pos = POS_ATNONDIR;
 		}
 
-		/* if no error during fine positioning, return.
+		/*
+		 * if no error during fine positioning, return.
 		 */
 		if (! rval) {
 			if (filehp) {
@@ -4667,7 +4949,8 @@ validate:
 			return RV_OK;
 		}
 
-		/* an error occurred during fine positioning. any other useful
+		/*
+		 * an error occurred during fine positioning. any other useful
 		 * media files on this object? if so, continue; if not, get
 		 * more media.
 		 */
@@ -4700,12 +4983,14 @@ validate:
 		/* fall through */
 
 newmedia:
-		/* invalidate prev id, so we log a TRACE msg for first
+		/*
+		 * invalidate prev id, so we log a TRACE msg for first
 		 * media file seen on new media
 		 */
 		uuid_clear(prevmfiledumpid);
 
-		/* if we are searching and some other thread completed
+		/*
+		 * if we are searching and some other thread completed
 		 * the search, don't pop the media unless it is useless
 		 */
 		if (purp == PURP_SEARCH
@@ -4720,26 +5005,30 @@ newmedia:
 			return RV_DONE;
 		}
 
-		/* if media not removable, just return
+		/*
+		 * if media not removable, just return
 		 */
 		if ((*dop->do_get_device_class)(drivep)
 		     ==
 		     DEVICE_NONREMOVABLE)
 		{
-		    /* if no error has already been detected then don't log
+		    /*
+		     * if no error has already been detected then don't log
 		       a failure */
 		    if (mlog_get_hint() == RV_NONE)
 			mlog_exit_hint(RV_OK);
 		    return RV_QUIT;
 		}
 
-		/* check for an interrupt
+		/*
+		 * check for an interrupt
 		 */
 		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
-		/* check if we are done.
+		/*
+		 * check if we are done.
 		 */
 		switch (purp) {
 		case PURP_SEARCH:
@@ -4766,14 +5055,16 @@ newmedia:
 		}
 
 		if (! bagp && ! knownholespr && ! maybeholespr) {
-			/* if PURP_DIR, this may be a problem
+			/*
+			 * if PURP_DIR, this may be a problem
 			 */
 			if (purp == PURP_NONDIR) {
 				return RV_NOMORE;
 			}
 		}
 
-		/* eject media if drive not already empty
+		/*
+		 * eject media if drive not already empty
 		 */
 		if (! emptypr) {
 			int dcaps = drivep->d_capabilities;
@@ -4795,11 +5086,13 @@ newmedia:
 			}
 		}
 
-		/* tell the persistent inventory this drive is now empty
+		/*
+		 * tell the persistent inventory this drive is now empty
 		 */
 		pi_driveempty(drivep->d_index);
 
-		/* invalidate all positional descriptors
+		/*
+		 * invalidate all positional descriptors
 		 */
 		Mediap->M_pos = POS_UNKN;
 		Mediap->M_flmfixvalpr = BOOL_FALSE;
@@ -4808,11 +5101,13 @@ newmedia:
 		fileh = DH_NULL;
 
 
-		/* ask for a media change: supply a list of media objects
+		/*
+		 * ask for a media change: supply a list of media objects
 		 * which may contain useful media files
 		 */
 		if (dlog_allowed()) {
-			/* If an alert program has been specified, run it.
+			/*
+			 * If an alert program has been specified, run it.
 			 */
 			if (media_change_alert_program != NULL)
 				system(media_change_alert_program);
@@ -4867,7 +5162,8 @@ newmedia:
 	/* NOTREACHED */
 }
 
-/* figures out and calls if needed do_end_read().
+/*
+ * figures out and calls if needed do_end_read().
  */
 static void
 Media_end(Media_t *Mediap)
@@ -4891,7 +5187,8 @@ Media_end(Media_t *Mediap)
 
 /* Persistent inventory operators *******************************************/
 
-/* the persistent inventory is an mmap()ed file containing a hierarchical
+/*
+ * the persistent inventory is an mmap()ed file containing a hierarchical
  * representation of all the media files generated by a dump session. it
  * is useful for asking questions about how much of the dump remains to
  * be restored.
@@ -4924,7 +5221,8 @@ pi_unlock(void)
 	qlock_unlock(tranp->t_pilockh);
 }
 
-/* sets check point in media file descriptor
+/*
+ * sets check point in media file descriptor
  */
 static void
 pi_checkpoint(dh_t fileh, drive_mark_t *drivemarkp, xfs_ino_t ino, off64_t off)
@@ -4936,7 +5234,8 @@ pi_checkpoint(dh_t fileh, drive_mark_t *drivemarkp, xfs_ino_t ino, off64_t off)
 	pi_unlock();
 }
 
-/* lock must be held by caller
+/*
+ * lock must be held by caller
  */
 static bool_t
 pi_allocdesc(dh_t *deschp)
@@ -4952,7 +5251,8 @@ pi_allocdesc(dh_t *deschp)
 		/* REFERENCED */
 		int rval;
 
-		/* first unmap if any existing descriptors
+		/*
+		 * first unmap if any existing descriptors
 		 */
 		if (descp) {
 			assert(olddescpgcnt > 0);
@@ -4964,7 +5264,8 @@ pi_allocdesc(dh_t *deschp)
 			assert(olddescpgcnt == 0);
 		}
 
-		/* remap with DAU more pages of descriptors
+		/*
+		 * remap with DAU more pages of descriptors
 		 */
 		assert(stpgcnt <= (ix_t)INTGENMAX);
 		assert(newdescpgcnt > 0);
@@ -5005,7 +5306,8 @@ pi_allocdesc(dh_t *deschp)
 	return BOOL_TRUE;
 }
 
-/* inserts the indexed file into the given stream. ensures that all
+/*
+ * inserts the indexed file into the given stream. ensures that all
  * previous files are represented as well. if dmfix is not valid, only
  * adds objects.
  */
@@ -5044,7 +5346,8 @@ pi_insertfile(ix_t drivecnt,
 
 	pi_lock();
 
-	/* first alloc stream descriptors if needed
+	/*
+	 * first alloc stream descriptors if needed
 	 */
 	if (persp->s.strmheadh == DH_NULL) {
 		for (strmix = 0; strmix < drivecnt; strmix++) {
@@ -5058,7 +5361,8 @@ pi_insertfile(ix_t drivecnt,
 		}
 	}
 
-	/* get handle to this stream
+	/*
+	 * get handle to this stream
 	 */
 	for (strmix = 0,
 	      strmh = persp->s.strmheadh
@@ -5070,7 +5374,8 @@ pi_insertfile(ix_t drivecnt,
 		;
 	assert(strmh != DH_NULL);
 
-	/* get handle to this object by walking/constructing this stream's
+	/*
+	 * get handle to this object by walking/constructing this stream's
 	 * object list, up to the desired object
 	 */
 	objh = prevobjh = DH_NULL;
@@ -5096,7 +5401,8 @@ pi_insertfile(ix_t drivecnt,
 		}
 	}
 
-	/* update the object fields if not yet valid
+	/*
+	 * update the object fields if not yet valid
 	 */
 	if (idlabvalpr
 	     &&
@@ -5124,7 +5430,8 @@ pi_insertfile(ix_t drivecnt,
 		DH2O(objh)->o_fmfsixvalpr = BOOL_TRUE;
 	}
 
-	/* record the previous object's id and label if not yet valid
+	/*
+	 * record the previous object's id and label if not yet valid
 	 */
 	if (prevobjh != DH_NULL
 	     &&
@@ -5138,7 +5445,8 @@ pi_insertfile(ix_t drivecnt,
 		DH2O(prevobjh)->o_idlabvalpr = BOOL_TRUE;
 	}
 
-	/* if the dump file and dump media file indices are valid,
+	/*
+	 * if the dump file and dump media file indices are valid,
 	 * and the previous object has at least one media file with its
 	 * dump file index valid, can infer the index of the last media
 	 * file on the previous dump object.
@@ -5180,7 +5488,8 @@ pi_insertfile(ix_t drivecnt,
 		pi_lock();
 	}
 
-	/* if don't know dump stream media file index, can't add any media files
+	/*
+	 * if don't know dump stream media file index, can't add any media files
 	 */
 	if (! dmfixvalpr) {
 		pi_unlock();
@@ -5188,7 +5497,8 @@ pi_insertfile(ix_t drivecnt,
 		return DH_NULL;
 	}
 
-	/* get handle to this file by walking/constructing this object's
+	/*
+	 * get handle to this file by walking/constructing this object's
 	 * file list, up to the desired file
 	 */
 	fileh = DH_NULL;
@@ -5214,7 +5524,8 @@ pi_insertfile(ix_t drivecnt,
 		}
 	}
 
-	/* update the media file fields not yet valid
+	/*
+	 * update the media file fields not yet valid
 	 */
 	if (egrpvalpr && ! DH2F(fileh)->f_valpr) {
 		assert(! (DH2F(fileh)->f_flags & PF_INV));
@@ -5225,11 +5536,13 @@ pi_insertfile(ix_t drivecnt,
 		DH2F(fileh)->f_valpr = BOOL_TRUE;
 	}
 
-	/* set flags
+	/*
+	 * set flags
 	 */
 	DH2F(fileh)->f_flags = flags;
 
-	/* if we know the file size,
+	/*
+	 * if we know the file size,
 	 * update it
 	 */
 	if (fileszvalpr) {
@@ -5242,7 +5555,8 @@ pi_insertfile(ix_t drivecnt,
 	return fileh;
 }
 
-/* add pers file desc if not already present. will automatically
+/*
+ * add pers file desc if not already present. will automatically
  * update/alloc pers obj and strm descriptors. If given a session inventory,
  * attempt to incorporate into pi. also, initializes completion stats.
  */
@@ -5266,7 +5580,8 @@ pi_addfile(Media_t *Mediap,
 		persp->s.stat_valpr = BOOL_TRUE;
 	}
 
-	/* if we see a terminator, we know we have seen the end of
+	/*
+	 * if we see a terminator, we know we have seen the end of
 	 * a stream.
 	 */
 	if (MEDIA_TERMINATOR_CHK(mrhdrp)) {
@@ -5299,10 +5614,12 @@ pi_addfile(Media_t *Mediap,
 		return fileh;
 	}
 
-	/* data file
+	/*
+	 * data file
 	 */
 	if (scrhdrp->cih_mediafiletype == CIH_MEDIAFILETYPE_DATA) {
-		/* tell the inventory about this media file
+		/*
+		 * tell the inventory about this media file
 		 */
 		fileh = pi_insertfile(drhdrp->dh_drivecnt,
 				       drhdrp->dh_driveix,
@@ -5330,7 +5647,8 @@ pi_addfile(Media_t *Mediap,
 		}
 		assert(drhdrp->dh_drivecnt > 0);
 		if (drhdrp->dh_driveix < drhdrp->dh_drivecnt - 1) {
-			/* if this is not in the last stream, we know
+			/*
+			 * if this is not in the last stream, we know
 			 * there is at least one other media file in
 			 * the following stream, and we know its start pt
 			 */
@@ -5357,7 +5675,8 @@ pi_addfile(Media_t *Mediap,
 					       (off64_t)0);
 		}
 		if (! (drivep->d_capabilities & DRIVE_CAP_FILES)) {
-			/* if drive does not support multiple files,
+			/*
+			 * if drive does not support multiple files,
 			 * we know this is end of object and stream
 			 */
 			pi_seestrmend(drhdrp->dh_driveix);
@@ -5367,7 +5686,8 @@ pi_addfile(Media_t *Mediap,
 		return fileh;
 	}
 
-	/* inventory file
+	/*
+	 * inventory file
 	 */
 	if (scrhdrp->cih_mediafiletype == CIH_MEDIAFILETYPE_INVENTORY) {
 		fileh = pi_insertfile(drhdrp->dh_drivecnt,
@@ -5432,17 +5752,20 @@ pi_addfile(Media_t *Mediap,
 			bool_t ok;
 			bool_t donepr;
 
-			/* read inventory into buffer
+			/*
+			 * read inventory into buffer
 			 */
 			bufszincr = IBPGINCR * PGSZ;
-				/* use 4096, no need to be correlated
+				/*
+				 * use 4096, no need to be correlated
 				 * with system page size
 				 */
 			bufsz = bufszincr;
 			buflen = 0;
 			bufp = (char *)malloc(bufsz);
 
-			/* need to read until we hit EOF/EOD. that's the only
+			/*
+			 * need to read until we hit EOF/EOD. that's the only
 			 * way to know how big the inventory is. mark the Media
 			 * current media file as no longer at hdr.
 			 */
@@ -5478,7 +5801,8 @@ pi_addfile(Media_t *Mediap,
 				}
 			}
 
-			/* ask inventory to convert buffer into session
+			/*
+			 * ask inventory to convert buffer into session
 			 * desc.
 			 */
 			sessp = 0;
@@ -5498,7 +5822,8 @@ pi_addfile(Media_t *Mediap,
 				      "on-media session "
 				      "inventory corrupt\n"));
 			} else {
-				/* if root, update online inventory.
+				/*
+				 * if root, update online inventory.
 				 */
 				if (! geteuid()
 				     &&
@@ -5510,7 +5835,8 @@ pi_addfile(Media_t *Mediap,
 					inv_put_sessioninfo(&sessinfo);
 				}
 
-				/* convert into pi format
+				/*
+				 * convert into pi format
 				 */
 				mlog(MLOG_VERBOSE | MLOG_MEDIA,
 				      "using on-media session inventory\n");
@@ -5526,7 +5852,8 @@ pi_addfile(Media_t *Mediap,
 	return DH_NULL;
 }
 
-/* translate a session inventory into a pi
+/*
+ * translate a session inventory into a pi
  */
 static bool_t
 pi_transcribe(inv_session_t *sessp)
@@ -5534,7 +5861,8 @@ pi_transcribe(inv_session_t *sessp)
 	ix_t strmcnt;
 	ix_t strmix;
 
-	/* traverse inventory, transcribing into pers inv.
+	/*
+	 * traverse inventory, transcribing into pers inv.
 	 */
 	strmcnt =  (size_t)sessp->s_nstreams;
 	for (strmix = 0; strmix < strmcnt; strmix++) {
@@ -5553,7 +5881,8 @@ pi_transcribe(inv_session_t *sessp)
 		mediaix = 0;
 		dumpmediafileix = 0;
 
-		/* insert all media files from this stream. note that
+		/*
+		 * insert all media files from this stream. note that
 		 * the media object representation is inverted
 		 */
 		for (fileix = 0; fileix < filecnt; fileix++) {
@@ -5614,7 +5943,8 @@ pi_transcribe(inv_session_t *sessp)
 	return BOOL_TRUE;
 }
 
-/* clean up pers. inv: initially no media objects in drives. flags may
+/*
+ * clean up pers. inv: initially no media objects in drives. flags may
  * be set from previously interrupted invocation.
  */
 static void
@@ -5646,7 +5976,8 @@ pi_preclean(void)
 	}
 }
 
-/* tell pi no media objects are in this drive
+/*
+ * tell pi no media objects are in this drive
  */
 static void
 pi_driveempty(ix_t driveix)
@@ -5686,7 +6017,8 @@ pi_driveempty(ix_t driveix)
 	pi_unlock();
 }
 
-/* tell pi this media object is in the drive
+/*
+ * tell pi this media object is in the drive
  */
 static void
 pi_note_indrive(ix_t driveix, uuid_t media_id)
@@ -5720,7 +6052,8 @@ done:
 	pi_unlock();
 }
 
-/* tell pi this media file is under the head of the drive containing the object
+/*
+ * tell pi this media file is under the head of the drive containing the object
  */
 static void
 pi_note_underhead(dh_t thisobjh, dh_t thisfileh)
@@ -5750,7 +6083,8 @@ pi_note_underhead(dh_t thisobjh, dh_t thisfileh)
 	pi_unlock();
 }
 
-/* mark the pi stream indicating all objects in that stream are known.
+/*
+ * mark the pi stream indicating all objects in that stream are known.
  */
 static void
 pi_seestrmend(ix_t strmix)
@@ -5760,7 +6094,8 @@ pi_seestrmend(ix_t strmix)
 
 	pi_lock();
 
-	/* get handle to the indexed stream
+	/*
+	 * get handle to the indexed stream
 	 */
 	for (ix = 0,
 	      strmh = persp->s.strmheadh
@@ -5771,7 +6106,8 @@ pi_seestrmend(ix_t strmix)
 	      strmh = DH2S(strmh)->s_nexth)
 		;
 
-	/* if an empty stream (can happen when dump interrupted),
+	/*
+	 * if an empty stream (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
 	if (strmh == DH_NULL) {
@@ -5779,7 +6115,8 @@ pi_seestrmend(ix_t strmix)
 		return;
 	}
 
-	/* set stream flag and object and file counts
+	/*
+	 * set stream flag and object and file counts
 	 */
 	DH2S(strmh)->s_lastobjknwnpr = BOOL_TRUE;
 
@@ -5787,7 +6124,8 @@ pi_seestrmend(ix_t strmix)
 	pi_show(" after pi_seestrmend");
 }
 
-/* mark pi indicating all media files in object are known
+/*
+ * mark pi indicating all media files in object are known
  */
 static void
 pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
@@ -5798,7 +6136,8 @@ pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 
 	pi_lock();
 
-	/* get handle to the indexed stream
+	/*
+	 * get handle to the indexed stream
 	 */
 	for (ix = 0,
 	      strmh = persp->s.strmheadh
@@ -5809,7 +6148,8 @@ pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 	      strmh = DH2S(strmh)->s_nexth)
 		;
 
-	/* if an empty stream (can happen when dump interrupted),
+	/*
+	 * if an empty stream (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
 	if (strmh == DH_NULL) {
@@ -5818,7 +6158,8 @@ pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 	}
 
 
-	/* get handle to indexed object in stream
+	/*
+	 * get handle to indexed object in stream
 	 */
 	for (ix = 0,
 	      objh = DH2S(strmh)->s_cldh
@@ -5829,7 +6170,8 @@ pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 	      objh = DH2O(objh)->o_nexth)
 		;
 
-	/* if an empty object (can happen when dump interrupted),
+	/*
+	 * if an empty object (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
 	if (objh == DH_NULL) {
@@ -5838,7 +6180,8 @@ pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 	}
 
 
-	/* set object flag
+	/*
+	 * set object flag
 	 */
 	DH2O(objh)->o_lmfknwnpr = BOOL_TRUE;
 
@@ -5846,7 +6189,8 @@ pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 	pi_show(" after pi_seeobjstrmend");
 }
 
-/* scans pi to determine ino of last file wholly or partially contained on
+/*
+ * scans pi to determine ino of last file wholly or partially contained on
  * this mfile. must err on the high side if partial info.
  * NOTE: assumes caller locks pi!
  */
@@ -5858,7 +6202,8 @@ pi_scanfileendino(dh_t fileh)
 
 	assert(fileh != DH_NULL);
 
-	/* traverse the pi tree, looking for the next media file after
+	/*
+	 * traverse the pi tree, looking for the next media file after
 	 */
 	for (strmh = persp->s.strmheadh
 	     ;
@@ -5909,7 +6254,8 @@ pi_scanfileendino(dh_t fileh)
 	return INO64MAX;
 }
 
-/* used to detemine range of extent groups still to be restored
+/*
+ * used to detemine range of extent groups still to be restored
  * from media file. *--o
  */
 static void
@@ -5923,7 +6269,8 @@ pi_bracketneededegrps(dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp)
 
 	assert(thisfileh != DH_NULL);
 
-	/* traverse the pi tree, looking for fileh
+	/*
+	 * traverse the pi tree, looking for fileh
 	 */
 	pi_lock();
 	assert(DH2F(thisfileh)->f_valpr);
@@ -5969,13 +6316,15 @@ done:
 
 	assert(thisfoundpr);
 
-	/* initially the lower bracket is this file descriptor's
+	/*
+	 * initially the lower bracket is this file descriptor's
 	 * current egrp. this catches the case where a previous restore
 	 * session was interrupted while restoring this media file.
 	 */
 	*first_egrp = DH2F(thisfileh)->f_curegrp;
 
-	/* if the closest valid preceeding media file's current egrp is
+	/*
+	 * if the closest valid preceeding media file's current egrp is
 	 * greater, use it as the lower bracket
 	 */
 	if (prech != DH_NULL
@@ -5984,7 +6333,8 @@ done:
 		*first_egrp = DH2F(prech)->f_curegrp;
 	}
 
-	/* the upper bracket is initially the end of the world.
+	/*
+	 * the upper bracket is initially the end of the world.
 	 * if we found a valid following file descriptor describing a
 	 * media file which has already been at least restored, use
 	 * its first egrp as an upper bracket.
@@ -6012,7 +6362,8 @@ pi_update_stats(off64_t sz)
 	pi_unlock();
 }
 
-/* pi_iterator - each invocation of the iterator advances to the next media file
+/*
+ * pi_iterator - each invocation of the iterator advances to the next media file
  * in the dump session, walking the media file hierarchy depth-wise. if
  * an object's file list is exhausted and the first media file in the next
  * object is returned and the exhausted object's last media file has not yet
@@ -6124,7 +6475,8 @@ pi_iter_nextfileh(pi_iter_t *iterp,
 	return iterp->fileh;
 }
 
-/* produces a list of media objects needed. also indicates if we know
+/*
+ * produces a list of media objects needed. also indicates if we know
  * some unidentified media objects are needed, and if it is possible
  * that we need some unidentifed objects, but don't know for sure.
  * if markskippr is set, set the f_nondirskipr flag if the media file
@@ -6159,7 +6511,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 	dh_t lastobjaddedh;
 	int objlistlen;
 
-	/* no point in proceeding if pi not begun
+	/*
+	 * no point in proceeding if pi not begun
 	 */
 	if (persp->s.strmheadh == DH_NULL) {
 		*knownholesprp = BOOL_TRUE;
@@ -6167,17 +6520,20 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 		return 0;
 	}
 
-	/* to hold a list of media object handles: caller must free
+	/*
+	 * to hold a list of media object handles: caller must free
 	 * using pi_neededobjs_free().
 	 */
 	bagp = bag_alloc();
 
-	/* allocate two iterators to scan pi
+	/*
+	 * allocate two iterators to scan pi
 	 */
 	tailiterp = pi_iter_alloc();
 	headiterp = pi_iter_alloc();
 
-	/* set the handle to the last file added to the list to NULL.
+	/*
+	 * set the handle to the last file added to the list to NULL.
 	 * this will be updated each time we add an object to the list,
 	 * preventing the same object from being added more than once.
 	 * this works because the media files for a given object will
@@ -6186,7 +6542,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 	lastobjaddedh = DH_NULL;
 	objlistlen = 0;
 
-	/* these will be set TRUE if the tail iterator ever indicates
+	/*
+	 * these will be set TRUE if the tail iterator ever indicates
 	 * we crossed an object or stream boundary and did not see a
 	 * valid last file  or last object respectively. can accumulate
 	 * the booleans, since iterator never sets FALSE, just TRUE.
@@ -6194,7 +6551,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 	maybeobjmissingpr = BOOL_FALSE;
 	maybefilemissingpr = BOOL_FALSE;
 
-	/* this will be set TRUE if we see a needed media file but the
+	/*
+	 * this will be set TRUE if we see a needed media file but the
 	 * object containing the media file has not been IDed.
 	 */
 	knownobjmissingpr = BOOL_FALSE;
@@ -6204,7 +6562,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 
 	tailh = DH_NULL;
 
-	/* lock up the inventory during the scan
+	/*
+	 * lock up the inventory during the scan
 	 */
 	pi_lock();
 
@@ -6212,7 +6571,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 		egrp_t headegrp;
 		bool_t foundgappr;
 
-		/* advance the head until we see the next media file which has
+		/*
+		 * advance the head until we see the next media file which has
 		 * a valid egrp, or until we run out of media files.
 		 */
 		do {
@@ -6231,7 +6591,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 			headegrp = DH2F(headh)->f_firstegrp;
 		}
 
-		/* see if the range of egrps from head up to but not including
+		/*
+		 * see if the range of egrps from head up to but not including
 		 * tail needed according to ino map
 		 */
 		if (gapneeded(&tailegrp, &headegrp)) {
@@ -6240,12 +6601,14 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 			foundgappr = BOOL_FALSE;
 		}
 
-		/* now bring tail up to head, adding objects and setting flags
+		/*
+		 * now bring tail up to head, adding objects and setting flags
 		 * along the way. note special handling of NULL tailh. possible
 		 * only first time through: ignore. also, ignore inv and term.
 		 */
 		do {
-		    /* if requested, mark media files not needed
+		    /*
+		     * if requested, mark media files not needed
 		     */
 		    if (markskippr
 			 &&
@@ -6261,7 +6624,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 			    DH2F(tailh)->f_nondirskippr = BOOL_TRUE;
 		    }
 
-		    /* build up list of needed objects
+		    /*
+		     * build up list of needed objects
 		     */
 		    if (foundgappr
 			 &&
@@ -6296,7 +6660,8 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 			    }
 		    }
 
-		    /* pull the tail up to the next media file
+		    /*
+		     * pull the tail up to the next media file
 		     */
 		    tailh = pi_iter_nextfileh(tailiterp,
 					       &maybeobjmissingpr,
@@ -6309,12 +6674,14 @@ pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 
 	pi_unlock();
 
-	/* free the iterators
+	/*
+	 * free the iterators
 	 */
 	pi_iter_free(tailiterp);
 	pi_iter_free(headiterp);
 
-	/* free the bag and return NULL if object list empty
+	/*
+	 * free the bag and return NULL if object list empty
 	 */
 	if (objlistlen == 0) {
 		bag_free(bagp);
@@ -6412,7 +6779,8 @@ pi_neededobjs_free(bag_t *bagp)
 	bag_free(bagp);
 }
 
-/* a macro predicate to indicate if we know we are done. if we are not
+/*
+ * a macro predicate to indicate if we know we are done. if we are not
  * done or don't know, returns FALSE.
  */
 static bool_t
@@ -6443,7 +6811,8 @@ pi_alldone(void)
 	}
 }
 
-/* tells the persistent inventory we hit end-of-data while examining the
+/*
+ * tells the persistent inventory we hit end-of-data while examining the
  * object specified by the index param. this tells us we've seen the end
  * of the stream as well as the end of the object.
  */
@@ -6458,7 +6827,8 @@ pi_hiteod(ix_t strmix, ix_t objix)
 
 	pi_lock();
 
-	/* get handle to the indexed stream
+	/*
+	 * get handle to the indexed stream
 	 */
 	for (ix = 0,
 	      strmh = persp->s.strmheadh
@@ -6470,7 +6840,8 @@ pi_hiteod(ix_t strmix, ix_t objix)
 		;
 	assert(strmh != DH_NULL);
 
-	/* get index to last object in stream
+	/*
+	 * get index to last object in stream
 	 */
 	for (objcnt = 0, objh = DH2S(strmh)->s_cldh
 	     ;
@@ -6483,7 +6854,8 @@ pi_hiteod(ix_t strmix, ix_t objix)
 
 	pi_unlock();
 
-	/* can't possibly happen, but check for case where pi indicates
+	/*
+	 * can't possibly happen, but check for case where pi indicates
 	 * other media objects beyond this one.
 	 */
 	if (objix != lastobjix) {
@@ -6500,7 +6872,8 @@ pi_hiteod(ix_t strmix, ix_t objix)
 	pi_seeobjstrmend(strmix, lastobjix);
 }
 
-/* tells the persistent inventory we hit end-of-media while examining the
+/*
+ * tells the persistent inventory we hit end-of-media while examining the
  * object specified by the index param. this tells us we've seen the end
  * of the object.
  */
@@ -6521,7 +6894,8 @@ pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix)
 
 	pi_lock();
 
-	/* get handle to the indexed stream
+	/*
+	 * get handle to the indexed stream
 	 */
 	for (ix = 0,
 	      strmh = persp->s.strmheadh
@@ -6533,7 +6907,8 @@ pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix)
 		;
 	assert(strmh != DH_NULL);
 
-	/* get index to last object in stream
+	/*
+	 * get index to last object in stream
 	 */
 	for (objcnt = 0, objh = DH2S(strmh)->s_cldh
 	     ;
@@ -6546,7 +6921,8 @@ pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix)
 
 	pi_unlock();
 
-	/* can't possibly happen, but check for case where pi indicates
+	/*
+	 * can't possibly happen, but check for case where pi indicates
 	 * other media objects beyond this one.
 	 */
 	if (objix != lastobjix) {
@@ -6564,7 +6940,8 @@ pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix)
 	pi_seeobjstrmend(strmix, lastobjix);
 }
 
-/* returns TRUE if pi is certain no more useful media files remaining
+/*
+ * returns TRUE if pi is certain no more useful media files remaining
  * on object. if any doubt, such as not knowing the last media file on
  * the object, returns FALSE.
  */
@@ -6580,7 +6957,8 @@ pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix)
 
 	pi_lock();
 
-	/* get handle to the indexed stream
+	/*
+	 * get handle to the indexed stream
 	 */
 	for (ix = 0,
 	      strmh = persp->s.strmheadh
@@ -6592,7 +6970,8 @@ pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix)
 		;
 	assert(strmh != DH_NULL);
 
-	/* get handle to indexed object
+	/*
+	 * get handle to indexed object
 	 */
 	for (ix = 0, objh = DH2S(strmh)->s_cldh
 	     ;
@@ -6603,14 +6982,16 @@ pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix)
 		;
 	assert(objh != DH_NULL);
 
-	/* if don't know last media file on object, return FALSE
+	/*
+	 * if don't know last media file on object, return FALSE
 	 */
 	if (! DH2O(objh)->o_lmfknwnpr) {
 		pi_unlock();
 		return BOOL_FALSE;
 	}
 
-	/* check all media files on object. if any are not marked done,
+	/*
+	 * check all media files on object. if any are not marked done,
 	 * return FALSE.
 	 */
 	for (fileh = DH2O(objh)->o_cldh
@@ -6658,7 +7039,8 @@ pi_know_no_more_beyond_on_object(purp_t purp,
 
 	pi_lock();
 
-	/* get handle to the indexed stream
+	/*
+	 * get handle to the indexed stream
 	 */
 	for (ix = 0,
 	      strmh = persp->s.strmheadh
@@ -6670,7 +7052,8 @@ pi_know_no_more_beyond_on_object(purp_t purp,
 		;
 	assert(strmh != DH_NULL);
 
-	/* get handle to indexed object
+	/*
+	 * get handle to indexed object
 	 */
 	for (ix = 0,
 	      objh = DH2S(strmh)->s_cldh
@@ -6682,14 +7065,16 @@ pi_know_no_more_beyond_on_object(purp_t purp,
 		;
 	assert(objh != DH_NULL);
 
-	/* if don't know last media file on object, return FALSE
+	/*
+	 * if don't know last media file on object, return FALSE
 	 */
 	if (! DH2O(objh)->o_lmfknwnpr) {
 		pi_unlock();
 		return BOOL_FALSE;
 	}
 
-	/* check all files on object after indexed file. if any are not marked
+	/*
+	 * check all files on object after indexed file. if any are not marked
 	 * done, return FALSE. skip inventory and terminator files.
 	 */
 	for (ix = 0,
@@ -6727,7 +7112,8 @@ pi_know_no_more_beyond_on_object(purp_t purp,
 	return BOOL_TRUE;
 }
 
-/* indicates if the given extent group range is called for by the
+/*
+ * indicates if the given extent group range is called for by the
  * ino map. *---o (endpoint not inclusive)
  */
 static bool_t
@@ -6804,7 +7190,8 @@ cntobj(bag_t *bagp)
 
 /* misc. static functions ***************************************************/
 
-/* queries inventory for the base of the given session. if the given session
+/*
+ * queries inventory for the base of the given session. if the given session
  * was a resumed dump, then must be last dump of same level. otherwise,
  * must be last dump of a lesser level
  */
@@ -6820,13 +7207,15 @@ askinvforbaseof(uuid_t baseid, inv_session_t *sessp)
 	level = (ix_t)sessp->s_level;
 	resumedpr = sessp->s_isresumed;
 
-	/* don't look for base if level 0 and not resumed
+	/*
+	 * don't look for base if level 0 and not resumed
 	 */
 	if (level == 0 && ! resumedpr) {
 		return BOOL_TRUE;
 	}
 
-	/* open the inventory for this file system
+	/*
+	 * open the inventory for this file system
 	 */
 	invtok = inv_open(INV_BY_UUID,
 			   INV_SEARCH_ONLY,
@@ -6837,7 +7226,8 @@ askinvforbaseof(uuid_t baseid, inv_session_t *sessp)
 		return BOOL_FALSE;
 	}
 
-	/* get the base session
+	/*
+	 * get the base session
 	 */
 	if (resumedpr) {
 		ok = inv_lastsession_level_equalto(&sessp->s_fsid,
@@ -6857,16 +7247,19 @@ askinvforbaseof(uuid_t baseid, inv_session_t *sessp)
 		return BOOL_FALSE;
 	}
 
-	/* close the inventory
+	/*
+	 * close the inventory
 	 */
 	ok = inv_close(invtok);
 	assert(ok);
 
-	/* return id of base session
+	/*
+	 * return id of base session
 	 */
         uuid_copy(baseid, basesessp->s_sesid);
 
-	/* free the base session descriptor
+	/*
+	 * free the base session descriptor
 	 */
 	inv_free_session(&basesessp);
 
@@ -6924,7 +7317,8 @@ dumpcompat(bool_t resumepr, ix_t level, uuid_t baseid, bool_t logpr)
 	return BOOL_TRUE;
 }
 
-/* prompts for a new media object. supplies list of media objects still
+/*
+ * prompts for a new media object. supplies list of media objects still
  * needed, and indicates if there are or may be unidentified media objects
  * still needed/available
  */
@@ -6963,7 +7357,8 @@ retry:
 	assert(preamblecnt <= PREAMBLEMAX);
 	dlog_begin(preamblestr, preamblecnt);
 
-	/* query: ask if media changed or declined
+	/*
+	 * query: ask if media changed or declined
 	 */
 	if (drivecnt > 1) {
 		sprintf(question, _(
@@ -7083,7 +7478,8 @@ retry:
 	return responseix == doix;
 }
 
-/* prompts the operator, asking if the current media file header describes
+/*
+ * prompts the operator, asking if the current media file header describes
  * the dump to be restored
  */
 static bool_t
@@ -7119,7 +7515,8 @@ retry:
 	assert(preamblecnt <= PREAMBLEMAX);
 	dlog_begin(preamblestr, preamblecnt);
 
-	/* display vital stats and ask if this one should be restored
+	/*
+	 * display vital stats and ask if this one should be restored
 	 */
 	if (drivecnt > 0) {
 		sprintf(introstring, _(
@@ -7216,7 +7613,8 @@ retry:
 	return responseix == doix;
 }
 
-/* restore_file - knows how to restore non-directory files
+/*
+ * restore_file - knows how to restore non-directory files
  *
  * uses the tree's callback iterator, which will call me for each
  * link to the specified inode.
@@ -7247,7 +7645,8 @@ restore_file(drive_t *drivep,
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	cb_context_t context;
 
-	/* ask the tree to call me back for each link to this inode.
+	/*
+	 * ask the tree to call me back for each link to this inode.
 	 * my callback will restore the file the first time it is
 	 * invoked, and create a hard link in subsequent calls.
 	 */
@@ -7272,7 +7671,8 @@ restore_file(drive_t *drivep,
 	    return rv;
 }
 
-/* called for each link to the file described by fhdr. the first
+/*
+ * called for each link to the file described by fhdr. the first
  * call is detected by noting linkpr is FALSE, and is used to create/
  * update the first link to the file, using path1. subsequent calls have
  * linkpr set false, and should link path1 to path2. if path1 is ever null,
@@ -7301,13 +7701,15 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
 
 	if (! linkpr) {
 		if (path1) {
-			/* cache the path for use in restoring attributes
+			/*
+			 * cache the path for use in restoring attributes
 			 * and extended attributes
 			 */
 			strcpy(strctxp->sc_path, path1);
 		}
 
-		/* call type-specific function to create the file
+		/*
+		 * call type-specific function to create the file
 		 */
 		switch (bstatp->bs_mode & S_IFMT) {
 		case S_IFREG:
@@ -7448,7 +7850,8 @@ done:
 	return 0;
 }
 
-/* called to begin a regular file. if no path given, or if just toc,
+/*
+ * called to begin a regular file. if no path given, or if just toc,
  * don't actually write, just read. also get into that situation if
  * cannot prepare destination. fd == -1 signifies no write. *statp
  * is set to indicate drive errors. returns FALSE if should abort
@@ -7547,7 +7950,8 @@ restore_reg(drive_t *drivep,
 
 	if (persp->a.dstdirisxfspr) {
 
-		/* set the extended inode flags, except those which must
+		/*
+		 * set the extended inode flags, except those which must
 		 * be set only after all data has been restored.
 		 */
 		assert(bstatp->bs_extsize >= 0);
@@ -7579,7 +7983,8 @@ restore_reg(drive_t *drivep,
 	return BOOL_TRUE;
 }
 
-/* called to peel a regular file's extent groups from the media.
+/*
+ * called to peel a regular file's extent groups from the media.
  * if no path given, or if just toc, don't actually write, just
  * read. fd == -1 signifies no write. *rvp is set to indicate
  * drive errors. returns FALSE if should abort this iteration.
@@ -7598,10 +8003,12 @@ restore_extent_group(drive_t *drivep,
 	off64_t bytesread;
 	rv_t rv;
 
-	/* copy data extents from media to the file
+	/*
+	 * copy data extents from media to the file
 	 */
 	for (;;) {
-		/* read the extent header
+		/*
+		 * read the extent header
 		 */
 		rv = read_extenthdr(drivep, &ehdr, ehcs);
 		if (rv != RV_OK) {
@@ -7615,11 +8022,13 @@ restore_extent_group(drive_t *drivep,
 		      ehdr.eh_sz,
 		      ehdr.eh_flags);
 
-		/* if we see the specially marked last extent hdr,
+		/*
+		 * if we see the specially marked last extent hdr,
 		 * we are done.
 		 */
 		if (ehdr.eh_type == EXTENTHDR_TYPE_LAST) {
-			/* For a wholly sparse file, there is no HOLE
+			/*
+			 * For a wholly sparse file, there is no HOLE
 			 * record; advance restoredsz to EOF.
 			 */
 			if (!restoredsz)
@@ -7627,7 +8036,8 @@ restore_extent_group(drive_t *drivep,
 			break;
 		}
 
-		/* if its an ALIGNment extent, discard the extent.
+		/*
+		 * if its an ALIGNment extent, discard the extent.
 		 */
 		if (ehdr.eh_type == EXTENTHDR_TYPE_ALIGN) {
 			size_t sz;
@@ -7641,19 +8051,22 @@ restore_extent_group(drive_t *drivep,
 			continue;
 		}
 
-		/* Add up extents restored to later check if the file
+		/*
+		 * Add up extents restored to later check if the file
 		 * is done.
 		 */
 		restoredsz += ehdr.eh_sz;  /* Increments of block size (usually 512) */
 
-		/* Holes do not need to be restored since we now
+		/*
+		 * Holes do not need to be restored since we now
 		 * unlink the file at the start of the restore.
 		 */
 		if (ehdr.eh_type == EXTENTHDR_TYPE_HOLE) {
 			continue;
 		}
 
-		/* real data
+		/*
+		 * real data
 		 */
 		assert(ehdr.eh_type == EXTENTHDR_TYPE_DATA);
 		bytesread = 0;
@@ -7674,7 +8087,8 @@ restore_extent_group(drive_t *drivep,
 		}
 	}
 
-	/* The extent group has been restored.  If the file is not
+	/*
+	 * The extent group has been restored.  If the file is not
 	 * complete, we may need to co-ordinate with other restore
 	 * streams to time the restoration of extended attributes
 	 * and certain extended inode flags. Register the portion
@@ -7691,7 +8105,8 @@ restore_extent_group(drive_t *drivep,
 	return BOOL_TRUE;
 }
 
-/* apply the attributes that can only go on now that all data
+/*
+ * apply the attributes that can only go on now that all data
  * and extended attributes have been applied. fd == -1 signifies
  * no write, due to unknown path or toc only.
  */
@@ -7716,7 +8131,8 @@ restore_complete_reg(stream_context_t *strcxtp)
 		return BOOL_TRUE;
 	}
 
-	/* set the access and modification times
+	/*
+	 * set the access and modification times
 	 */
 	utimbuf.actime = (time32_t)bstatp->bs_atime.tv_sec;
 	utimbuf.modtime = (time32_t)bstatp->bs_mtime.tv_sec;
@@ -7729,7 +8145,8 @@ restore_complete_reg(stream_context_t *strcxtp)
 		      strerror(errno));
 	}
 
-	/* set the owner and group (if enabled)
+	/*
+	 * set the owner and group (if enabled)
 	 */
 	if (strcxtp->sc_ownerset == BOOL_FALSE && persp->a.ownerpr) {
 		rval = set_file_owner(path, &fd, strcxtp);
@@ -7737,7 +8154,8 @@ restore_complete_reg(stream_context_t *strcxtp)
 			return BOOL_TRUE;
 	}
 
-	/* set the permissions/mode
+	/*
+	 * set the permissions/mode
 	 */
 	rval = fchmod(fd, (mode_t)bstatp->bs_mode);
 	if (rval) {
@@ -7767,7 +8185,8 @@ restore_complete_reg(stream_context_t *strcxtp)
 		HsmEndRestoreFile(path, fd, &strcxtp->sc_hsmflags);
 	}
 
-	/* set any extended inode flags that couldn't be set
+	/*
+	 * set any extended inode flags that couldn't be set
 	 * prior to restoring the data.
 	 */
 	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & POST_DATA_XFLAGS) {
@@ -7897,7 +8316,8 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 			(void)close(sockfd);
 
 		} else {
-			/* create the node
+			/*
+			 * create the node
 			*/
 			rval = mknod(path,
 				      (mode_t)bstatp->bs_mode,
@@ -7914,7 +8334,8 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 			}
 		}
 
-		/* set the owner and group (if enabled)
+		/*
+		 * set the owner and group (if enabled)
 		 */
 		if (persp->a.ownerpr) {
 			rval = chown(path,
@@ -7931,7 +8352,8 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 			}
 		}
 
-		/* set the permissions/mode
+		/*
+		 * set the permissions/mode
 		 */
 		rval = chmod(path, (mode_t)fhdrp->fh_stat.bs_mode);
 		if (rval) {
@@ -7941,7 +8363,8 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 			      strerror(errno));
 		}
 
-		/* set the access and modification times
+		/*
+		 * set the access and modification times
 		 */
 		utimbuf.actime = (time32_t)bstatp->bs_atime.tv_sec;
 		utimbuf.modtime = (time32_t)bstatp->bs_mtime.tv_sec;
@@ -7988,7 +8411,8 @@ restore_symlink(drive_t *drivep,
 		}
 	}
 
-	/* read the extent header
+	/*
+	 * read the extent header
 	 */
 	rv = read_extenthdr(drivep, &ehdr, ehcs);
 	if (rv != RV_OK) {
@@ -7996,11 +8420,13 @@ restore_symlink(drive_t *drivep,
 		return BOOL_FALSE;
 	}
 
-	/* symlinks always have one extent
+	/*
+	 * symlinks always have one extent
 	 */
 	assert(ehdr.eh_type == EXTENTHDR_TYPE_DATA);
 
-	/* read the link path extent
+	/*
+	 * read the link path extent
 	 */
 	if (ehdr.eh_sz < (off64_t)(2 * MAXPATHLEN)) {
 		scratch = scratchpath;
@@ -8046,9 +8472,11 @@ restore_symlink(drive_t *drivep,
 	}
 	scratchpath[nread] = 0;
 	if (! tranp->t_toconlypr && path) {
-		/* create the symbolic link
+		/*
+		 * create the symbolic link
 		 */
-		/* NOTE: There is no direct way to set mode for
+		/*
+		 * NOTE: There is no direct way to set mode for
 		 * sym links. Do it using umask.
 		 * No way of setting times for sym links.
 		 */
@@ -8069,7 +8497,8 @@ restore_symlink(drive_t *drivep,
 			return BOOL_TRUE;
 		}
 
-		/* set the owner and group (if enabled)
+		/*
+		 * set the owner and group (if enabled)
 		 */
 		if (persp->a.ownerpr) {
 			rval = lchown(path,
@@ -8238,7 +8667,8 @@ read_dirent(drive_t *drivep,
 	assert(sizeof(direnthdr_t) == DIRENTHDR_SZ);
 	assert(sizeof(direnthdr_v1_t) == DIRENTHDR_SZ);
 
-	/* read the head of the dirent
+	/*
+	 * read the head of the dirent
 	 */
 	nread = read_buf((char *)&tmpdh,
 			  DIRENTHDR_SZ,
@@ -8303,14 +8733,16 @@ read_dirent(drive_t *drivep,
 		return RV_CORRUPT;
 	}
 
-	/* if null, return
+	/*
+	 * if null, return
 	 */
 	if (dhdrp->dh_ino == 0) {
 		assert((size_t)dhdrp->dh_sz == sizeof(direnthdr_t));
 		return RV_OK;
 	}
 
-	/* read the remainder of the dirent.
+	/*
+	 * read the remainder of the dirent.
 	 */
 	assert((size_t)dhdrp->dh_sz <= direntbufsz);
 	assert((size_t)dhdrp->dh_sz >= sizeof(direnthdr_t));
@@ -8398,7 +8830,8 @@ read_extattrhdr(drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs)
 				return RV_CORRUPT;
 			}
 		} else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_OLD_CHECKSUM) {
-			/* possibly a corrupt header, but most likely an old
+			/*
+			 * possibly a corrupt header, but most likely an old
 			 * header, which cannot be verified due to a bug in how
 			 * its checksum was calculated.
 			 */
@@ -8472,7 +8905,8 @@ restore_extent(filehdr_t *fhdrp,
 
 	if (fd != -1) {
 		assert(path);
-		/* seek to the beginning of the extent.
+		/*
+		 * seek to the beginning of the extent.
 		 * must be on a basic fs blksz boundary.
 		 */
 		assert((off & (off64_t)(BBSIZE - 1)) == 0);
@@ -8504,7 +8938,8 @@ restore_extent(filehdr_t *fhdrp,
 			isrealtime = BOOL_TRUE;
 	}
 
-	/* move from media to fs.
+	/*
+	 * move from media to fs.
 	 */
 	while (sz) {
 		char *bufp;
@@ -8681,7 +9116,8 @@ restore_extent(filehdr_t *fhdrp,
 				      off,
 				      nwritten);
 			}
-			/* stop attempting to write, but complete reads
+			/*
+			 * stop attempting to write, but complete reads
 			 */
 			fd = -1;
 			assert(ntowrite <= (size_t)INTGENMAX);
@@ -8753,7 +9189,8 @@ restore_extattr(drive_t *drivep,
 	if (! isdirpr)
 		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
 
-	/* peel off extattrs until null hdr hit
+	/*
+	 * peel off extattrs until null hdr hit
 	 */
 	for (;;) {
 		size_t recsz;
@@ -8805,7 +9242,8 @@ restore_extattr(drive_t *drivep,
 		if (onlydoreadpr || tranp->t_toconlypr)
 			continue;
 
-		/* NOTE: In the cases below, if we get errors then we issue warnings
+		/*
+		 * NOTE: In the cases below, if we get errors then we issue warnings
 		 * but we do not stop the restoration.
 		 * We can still restore the file possibly without the
 		 * extended attributes.
@@ -8846,7 +9284,8 @@ restore_dir_extattr_cb(char *path, dah_t dah)
 	extattrhdr_t *ahdrp = (extattrhdr_t *)get_extattrbuf(0);
 	bool_t ok;
 
-	/* ask the dirattr abstraction to call me back for each
+	/*
+	 * ask the dirattr abstraction to call me back for each
 	 * extended dirattr associated with this dah.
 	 */
 	ok = dirattr_cb_extattr(dah,
@@ -8879,7 +9318,8 @@ setextattr(char *path, extattrhdr_t *ahdrp)
 	isdmpr = (isrootpr &&
 		   !strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1));
 
-	/* If restoreextattrpr not set, then we are here because -D was
+	/*
+	 * If restoreextattrpr not set, then we are here because -D was
 	 * specified. So return unless it looks like a root DMAPI attribute.
 	 */
 	if (!persp->a.restoreextattrpr && !isdmpr)
@@ -8958,7 +9398,8 @@ dump_partials(void)
 }
 
 
-/* There can only be at most 2 partials for a given stream.
+/*
+ * There can only be at most 2 partials for a given stream.
  * An unfinished one from a split and the current one from
  * a multiple group extent or another split.
  * If there are more than 2, then there is an internal error.
@@ -9008,7 +9449,8 @@ check_valid_partials(void)
 }
 #endif
 
-/* partial_reg - Registers files that are only partially restored by
+/*
+ * partial_reg - Registers files that are only partially restored by
  * a dump stream into the persistent state.
  *
  * This is done because DMAPI extended attributes must not be set until
@@ -9043,7 +9485,8 @@ partial_reg(ix_t d_index,
 
 	pi_lock();
 
-	/* Search for a matching inode.  Gaps can exist so we must search
+	/*
+	 * Search for a matching inode.  Gaps can exist so we must search
 	 * all entries.
 	 */
 	for (i=0; i < partialmax; i++) {
@@ -9066,7 +9509,8 @@ partial_reg(ix_t d_index,
 				isptr->is_ino = ino;
 				persp->a.parrestcnt++;
 
-				/* Clear all endoffsets (this value is
+				/*
+				 * Clear all endoffsets (this value is
 				 * used to decide if an entry is used or
 				 * not
 				 */
@@ -9103,7 +9547,8 @@ found:
 	} else {
 		bool_t ret;
 
-		/* entry exists for this drive, just extend the endoffset, the
+		/*
+		 * entry exists for this drive, just extend the endoffset, the
 		 * records will be sequential for any given drive.
 		 */
 		bsptr->endoffset = endoffset;
@@ -9124,7 +9569,8 @@ found:
 }
 
 
-/* Checks the registry of files that are only partially restored by
+/*
+ * Checks the registry of files that are only partially restored by
  * any given dump stream to see if the remainder of the file has
  * been restored by another dump stream.
  */
@@ -9146,7 +9592,8 @@ partial_check (xfs_ino_t ino, off64_t fsize)
 		return BOOL_TRUE;
 	}
 
-	/* Search for the inode.  Gaps can exist so we must search
+	/*
+	 * Search for the inode.  Gaps can exist so we must search
 	 * all entries.
 	 */
 	for (i=0; i < partialmax; i++) {
@@ -9187,7 +9634,8 @@ partial_check2(partial_rest_t *isptr, off64_t fsize)
 	int i;
 
 gapsearch:
-	/* Search the entire set of bytespan records to see if the next
+	/*
+	 * Search the entire set of bytespan records to see if the next
 	 * span has been restored.  Bytespans are not necessarily in order
 	 * so the search is repeated from the start each time.
 	 */
@@ -9240,7 +9688,8 @@ content_overwrite_ok(char *path,
 
 	*exists = BOOL_TRUE;
 
-	/* if file doesn't exist, allow
+	/*
+	 * if file doesn't exist, allow
 	 */
 
 	if (lstat(path, &statbuf)) {
@@ -9251,14 +9700,16 @@ content_overwrite_ok(char *path,
 		return BOOL_TRUE;
 	}
 
-	/* if overwrites absolutely inhibited, disallow
+	/*
+	 * if overwrites absolutely inhibited, disallow
 	 */
 	if (persp->a.existpr) {
 		*reasonstrp = _("overwrites inhibited");
 		return BOOL_FALSE;
 	}
 
-	/* if newer time specified, compare
+	/*
+	 * if newer time specified, compare
 	 */
 	if (persp->a.newerpr) {
 		if ((time32_t)ctime < persp->a.newertime) {
@@ -9267,7 +9718,8 @@ content_overwrite_ok(char *path,
 		}
 	}
 
-	/* don't overwrite changed files
+	/*
+	 * don't overwrite changed files
 	 */
 	if (persp->a.changepr) {
 		if (statbuf.st_ctime >= (time32_t)ctime) {
@@ -9347,7 +9799,8 @@ pi_show_nomloglock(void)
 	int strmix;
 
 
-	/* no point in proceeding if pi not begun
+	/*
+	 * no point in proceeding if pi not begun
 	 */
 	if (persp->s.strmheadh == DH_NULL) {
 		mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA, _(
@@ -9358,7 +9811,8 @@ pi_show_nomloglock(void)
 	mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA, _(
 	      "session inventory display\n"));
 
-	/* iterate over all streams
+	/*
+	 * iterate over all streams
 	 */
 	for (strmh = persp->s.strmheadh, strmix = 0
 	     ;
@@ -9376,7 +9830,8 @@ pi_show_nomloglock(void)
 			      _("\n    media objects not yet identified\n"));
 			continue;
 		}
-		/* iterate over all objects
+		/*
+		 * iterate over all objects
 		 */
 		for (objh = DH2S(strmh)->s_cldh, objix = 0
 		     ;
@@ -9443,7 +9898,8 @@ pi_show_nomloglock(void)
 				continue;
 			}
 
-			/* iterate over all files
+			/*
+			 * iterate over all files
 			 */
 			for (fileh = DH2O(objh)->o_cldh, fileix = 0
 			     ;
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 36b60dc..803a966 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -57,11 +57,13 @@
 
 /* structure definitions used locally ****************************************/
 
-/* node handle limits
+/*
+ * node handle limits
  */
 #ifdef DIRATTRCHK
 
-/* macros for manipulating dirattr handles when handle consistency
+/*
+ * macros for manipulating dirattr handles when handle consistency
  * checking is enabled. the upper bits of a handle will be loaded
  * with a handle checksum.
  */
@@ -83,7 +85,8 @@
 					  ((int)d & HDLDIXMASK)))
 #define DIX_MAX			((off64_t)HDLDIXMASK)
 
-/* each dirattr will hold two check fields: a handle checksum, and unique
+/*
+ * each dirattr will hold two check fields: a handle checksum, and unique
  * pattern, to differentiate a valid dirattr from random file contents.
  */
 #define DIRATTRUNQ		0xa116
@@ -100,7 +103,8 @@
 
 #endif /* DIRATTRCHK */
 
-/* dirattr definition
+/*
+ * dirattr definition
  */
 struct dirattr {
 #ifdef DIRATTRCHK
@@ -125,7 +129,8 @@ typedef struct dirattr dirattr_t;
 
 #define DIRATTR_EXTATTROFFNULL	((off64_t)OFF64MAX)
 
-/* dirattr persistent context definition
+/*
+ * dirattr persistent context definition
  */
 struct dirattr_pers {
 	off64_t dp_appendoff;
@@ -135,7 +140,8 @@ typedef struct dirattr_pers dirattr_pers_t;
 
 #define DIRATTR_PERS_SZ	pgsz
 
-/* dirattr transient context definition
+/*
+ * dirattr transient context definition
  */
 
 #define	DIRATTR_BUFSIZE	32768
@@ -156,7 +162,8 @@ struct dirattr_tran {
 typedef struct dirattr_tran dirattr_tran_t;
 
 
-/* a dirattr is identified internally by its index into the backing store.
+/*
+ * a dirattr is identified internally by its index into the backing store.
  * this index is the offset of the dirattr (relative to the end of the dirattr
  * persistent state hdr) into the backing store divided by the size of a
  * dirattr. a special index is reserved to represent the null index. a type
@@ -205,13 +212,15 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 		return BOOL_TRUE;
 	}
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(sizeof(dirattr_pers_t) <= DIRATTR_PERS_SZ);
 	assert(! dtp);
 	assert(! dpp);
 
-	/* allocate and initialize context
+	/*
+	 * allocate and initialize context
 	 */
 	dtp = (dirattr_tran_t *)calloc(1, sizeof(dirattr_tran_t));
 	assert(dtp);
@@ -219,14 +228,17 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 	dtp->dt_fd = -1;
 	dtp->dt_extattrfd = -1;
 
-	/* generate a string containing the pathname of the dirattr file
+	/*
+	 * generate a string containing the pathname of the dirattr file
 	 */
 	dtp->dt_pathname = open_pathalloc(hkdir, dirattrfile, 0);
 
-	/* open the dirattr file
+	/*
+	 * open the dirattr file
 	 */
 	if (resume) {
-		/* open existing file
+		/*
+		 * open existing file
 		 */
 		dtp->dt_fd = open(dtp->dt_pathname, O_RDWR);
 		if (dtp->dt_fd < 0) {
@@ -238,7 +250,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 			return BOOL_FALSE;
 		}
 	} else {
-		/* create the dirattr file, first unlinking any older version
+		/*
+		 * create the dirattr file, first unlinking any older version
 		 * laying around
 		 */
 		(void)unlink(dtp->dt_pathname);
@@ -254,7 +267,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 			return BOOL_FALSE;
 		}
 
-		/* reserve space for the backing store. try to use RESVSP64.
+		/*
+		 * reserve space for the backing store. try to use RESVSP64.
 		 * if doesn't work, try ALLOCSP64. the former is faster, as
 		 * it does not zero the space.
 		 */
@@ -312,7 +326,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 		}
 	}
 
-	/* mmap the persistent descriptor
+	/*
+	 * mmap the persistent descriptor
 	 */
 	assert(! (DIRATTR_PERS_SZ % pgsz));
 	dpp = (dirattr_pers_t *)mmap_autogrow(DIRATTR_PERS_SZ,
@@ -327,17 +342,20 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 		return BOOL_FALSE;
 	}
 
-	/* initialize persistent state
+	/*
+	 * initialize persistent state
 	 */
 	if (! resume) {
 		dpp->dp_appendoff = (off64_t)DIRATTR_PERS_SZ;
 	}
 
-	/* initialize transient state
+	/*
+	 * initialize transient state
 	 */
 	dtp->dt_at_endpr = BOOL_FALSE;
 
-	/* calculate the dir extattr pathname, and set the fd to -1.
+	/*
+	 * calculate the dir extattr pathname, and set the fd to -1.
 	 * file will be created on demand.
 	 */
 	dtp->dt_extattrpathname = open_pathalloc(hkdir, dirextattrfile, 0);
@@ -396,12 +414,14 @@ dirattr_add(filehdr_t *fhdrp)
 #endif /* DIRATTRCHK */
 	dah_t dah;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(dtp);
 	assert(dpp);
 
-	/* make sure file pointer is positioned to write at end of file
+	/*
+	 * make sure file pointer is positioned to write at end of file
 	 */
 	if (! dtp->dt_at_endpr) {
 		off64_t newoff;
@@ -422,13 +442,15 @@ dirattr_add(filehdr_t *fhdrp)
 		}
 	}
 
-	/* calculate the index of this dirattr
+	/*
+	 * calculate the index of this dirattr
 	 */
 	oldoff = dpp->dp_appendoff;
 	dix = OFF2DIX(oldoff);
 	assert(dix <= DIX_MAX);
 
-	/* populate a dirattr
+	/*
+	 * populate a dirattr
 	 */
 	dirattr.d_mode = (mode_t)fhdrp->fh_stat.bs_mode;
 	dirattr.d_uid = (uid_t)fhdrp->fh_stat.bs_uid;
@@ -448,12 +470,14 @@ dirattr_add(filehdr_t *fhdrp)
 #endif /* DIRATTRCHK */
 	dirattr.d_extattroff = DIRATTR_EXTATTROFFNULL;
 
-	/* write the entry into our buffer
+	/*
+	 * write the entry into our buffer
 	 */
 	memcpy(dtp->dt_buf + dtp->dt_off, (void *)&dirattr, sizeof(dirattr_t));
 	dtp->dt_off += sizeof(dirattr_t);
 
-	/* update the next write offset
+	/*
+	 * update the next write offset
 	 */
 	assert(dpp->dp_appendoff <= OFF64MAX - (off64_t)sizeof(dirattr_t));
 	dpp->dp_appendoff += (off64_t)sizeof(dirattr_t);
@@ -477,11 +501,13 @@ dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
 	int nread;
 	int nwritten;
 
-	/* pull the selected dir attributes into the cache
+	/*
+	 * pull the selected dir attributes into the cache
 	 */
 	dirattr_get(dah);
 
-	/* open/create extended attributes file if not yet done
+	/*
+	 * open/create extended attributes file if not yet done
 	 */
 	if (dtp->dt_extattrfd < 0) {
 		if (dtp->dt_extattrfdbadpr) {
@@ -503,7 +529,8 @@ dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
 		}
 	}
 
-	/* seek to the end of the dir extattr list
+	/*
+	 * seek to the end of the dir extattr list
 	 */
 	off = dtp->dt_cached_dirattr.d_extattroff;
 	oldoff = DIRATTR_EXTATTROFFNULL;
@@ -540,7 +567,8 @@ dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
 		}
 	}
 
-	/* append the extended attributes
+	/*
+	 * append the extended attributes
 	 */
 	off = lseek64(dtp->dt_extattrfd, 0, SEEK_END);
 	if (off < 0) {
@@ -582,7 +610,8 @@ dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
 		return;
 	}
 
-	/* fill in the offset of the extended attributes into the
+	/*
+	 * fill in the offset of the extended attributes into the
 	 * linked list
 	 */
 	if (oldoff == DIRATTR_EXTATTROFFNULL) {
@@ -628,11 +657,13 @@ dirattr_cb_extattr(dah_t dah,
 {
 	off64_t off;
 
-	/* pull the selected dir attributes into the cache
+	/*
+	 * pull the selected dir attributes into the cache
 	 */
 	dirattr_get(dah);
 
-	/* open/create extended attributes file if not yet done
+	/*
+	 * open/create extended attributes file if not yet done
 	 */
 	if (dtp->dt_extattrfd < 0) {
 		if (dtp->dt_extattrfdbadpr) {
@@ -654,7 +685,8 @@ dirattr_cb_extattr(dah_t dah,
 		}
 	}
 
-	/* walk through the dirattr list for this dah
+	/*
+	 * walk through the dirattr list for this dah
 	 */
 	off = dtp->dt_cached_dirattr.d_extattroff;
 	while (off != DIRATTR_EXTATTROFFNULL) {
@@ -664,7 +696,8 @@ dirattr_cb_extattr(dah_t dah,
 		size_t recsz;
 		bool_t ok;
 
-		/* seek to the extattr
+		/*
+		 * seek to the extattr
 		 */
 		seekoff = lseek64(dtp->dt_extattrfd, off, SEEK_SET);
 		if (seekoff < 0) {
@@ -680,7 +713,8 @@ dirattr_cb_extattr(dah_t dah,
 		}
 		assert(seekoff == off);
 
-		/* peel off the next offset
+		/*
+		 * peel off the next offset
 		 */
 		nread = read(dtp->dt_extattrfd,
 			      (void *)&nextoff,
@@ -697,7 +731,8 @@ dirattr_cb_extattr(dah_t dah,
 			return BOOL_TRUE;
 		}
 
-		/* read the extattr hdr
+		/*
+		 * read the extattr hdr
 		 */
 		nread = read(dtp->dt_extattrfd,
 			      (void *)ahdrp,
@@ -714,7 +749,8 @@ dirattr_cb_extattr(dah_t dah,
 			return BOOL_TRUE;
 		}
 
-		/* read the remainder of the extattr
+		/*
+		 * read the remainder of the extattr
 		 */
 		recsz = (size_t)ahdrp->ah_sz;
 		assert(recsz >= EXTATTRHDR_SZ);
@@ -733,14 +769,16 @@ dirattr_cb_extattr(dah_t dah,
 			return BOOL_TRUE;
 		}
 
-		/* call the callback func
+		/*
+		 * call the callback func
 		 */
 		ok = (*cbfunc)(ahdrp, ctxp);
 		if (! ok) {
 			return BOOL_FALSE;
 		}
 
-		/* go th the next one
+		/*
+		 * go th the next one
 		 */
 		off = nextoff;
 	}
@@ -760,7 +798,8 @@ dirattr_update(dah_t dah, filehdr_t *fhdrp)
 	dirattr_t dirattr;
 	int nwritten;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(dtp);
 	assert(dpp);
@@ -795,7 +834,8 @@ dirattr_update(dah_t dah, filehdr_t *fhdrp)
 		}
 	}
 
-	/* seek to the dirattr
+	/*
+	 * seek to the dirattr
 	 */
 	newoff = lseek64(dtp->dt_fd, argoff, SEEK_SET);
 	if (newoff == (off64_t)-1) {
@@ -806,7 +846,8 @@ dirattr_update(dah_t dah, filehdr_t *fhdrp)
 	}
 	assert(newoff == argoff);
 
-	/* populate a dirattr
+	/*
+	 * populate a dirattr
 	 */
 	dirattr.d_mode = (mode_t)fhdrp->fh_stat.bs_mode;
 	dirattr.d_uid = (uid_t)fhdrp->fh_stat.bs_uid;
@@ -821,7 +862,8 @@ dirattr_update(dah_t dah, filehdr_t *fhdrp)
 	dirattr.d_dmstate = (uint32_t)fhdrp->fh_stat.bs_dmstate;
 	dirattr.d_extattroff = DIRATTR_EXTATTROFFNULL;
 
-	/* write the dirattr
+	/*
+	 * write the dirattr
 	 */
 	nwritten = write(dtp->dt_fd, (void *)&dirattr, sizeof(dirattr));
 	if ((size_t)nwritten != sizeof(dirattr)) {
@@ -923,12 +965,14 @@ dirattr_flush()
 {
 	ssize_t nwritten;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	*/
 	assert (dtp);
 
 	if (dtp->dt_off) {
-		/* write the accumulated dirattr entries
+		/*
+		 * write the accumulated dirattr entries
 		*/
 		nwritten = write(dtp->dt_fd, (void *)dtp->dt_buf, dtp->dt_off);
 		if (nwritten != dtp->dt_off) {
@@ -963,14 +1007,16 @@ dirattr_get(dah_t dah)
 	uint16_t sum;
 #endif /* DIRATTRCHK */
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(dtp);
 	assert(dpp);
 
 	assert(dah != DAH_NULL);
 
-	/* if we are already holding this dirattr in cache,
+	/*
+	 * if we are already holding this dirattr in cache,
 	 * just return
 	 */
 	if (dtp->dt_cachedh == dah) {
@@ -998,7 +1044,8 @@ dirattr_get(dah_t dah)
 		}
 	}
 
-	/* seek to the dirattr
+	/*
+	 * seek to the dirattr
 	 */
 	newoff = lseek64(dtp->dt_fd, argoff, SEEK_SET);
 	if (newoff == (off64_t)-1) {
@@ -1009,7 +1056,8 @@ dirattr_get(dah_t dah)
 	}
 	assert(newoff == argoff);
 
-	/* read the dirattr
+	/*
+	 * read the dirattr
 	 */
 	nread = read(dtp->dt_fd,
 		      (void *)&dtp->dt_cached_dirattr,
@@ -1042,12 +1090,14 @@ dirattr_cacheflush(void)
 	off64_t newoff;
 	int nwritten;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(dtp);
 	assert(dpp);
 
-	/* if nothing in the cache, ignore
+	/*
+	 * if nothing in the cache, ignore
 	 */
 	dah = dtp->dt_cachedh;
 	assert(dah != DAH_NULL);
@@ -1075,7 +1125,8 @@ dirattr_cacheflush(void)
 	assert(argoff >= (off64_t)DIRATTR_PERS_SZ);
 	assert(argoff <= dpp->dp_appendoff - (off64_t)sizeof(dirattr_t));
 
-	/* seek to the dirattr
+	/*
+	 * seek to the dirattr
 	 */
 	newoff = lseek64(dtp->dt_fd, argoff, SEEK_SET);
 	if (newoff == (off64_t)-1) {
@@ -1086,7 +1137,8 @@ dirattr_cacheflush(void)
 	}
 	assert(newoff == argoff);
 
-	/* write the dirattr
+	/*
+	 * write the dirattr
 	 */
 	nwritten = write(dtp->dt_fd,
 			  (void *)&dtp->dt_cached_dirattr,
diff --git a/restore/dirattr.h b/restore/dirattr.h
index 232822e..51b7ae2 100644
--- a/restore/dirattr.h
+++ b/restore/dirattr.h
@@ -18,7 +18,8 @@
 #ifndef DIRATTR_H
 #define DIRATTR_H
 
-/* dah_t - handle to registered directory attributes
+/*
+ * dah_t - handle to registered directory attributes
  * a special handle is reserved for the caller's convenience,
  * to indicate no directory attributes have been registered.
  */
@@ -26,7 +27,8 @@ typedef size32_t dah_t;
 #define	DAH_NULL	SIZE32MAX
 
 
-/* dirattr_init - creates the directory attributes registry.
+/*
+ * dirattr_init - creates the directory attributes registry.
  * resync indicates if an existing context should be re-opened.
  * returns FALSE if an error encountered. if NOT resync,
  * dircnt hints at number of directories to expect.
@@ -36,25 +38,30 @@ extern bool_t dirattr_init(char *housekeepingdir,
 			    uint64_t dircnt);
 
 
-/* dirattr_cleanup - removes all traces
+/*
+ * dirattr_cleanup - removes all traces
  */
 extern void dirattr_cleanup(void);
 
 
-/* dirattr_add - registers a directory's attributes. knows how to interpret
+/*
+ * dirattr_add - registers a directory's attributes. knows how to interpret
  * the filehdr. returns handle for use with dirattr_get_...().
  */
 extern dah_t dirattr_add(filehdr_t *fhdrp);
 
-/* dirattr_update - modifies existing registered attributes
+/*
+ * dirattr_update - modifies existing registered attributes
  */
 extern void dirattr_update(dah_t dah, filehdr_t *fhdrp);
 
-/* dirattr_del - frees dirattr no longer needed
+/*
+ * dirattr_del - frees dirattr no longer needed
  */
 extern void dirattr_del(dah_t dah);
 
-/* dirattr_get_... - retrieve various attributes
+/*
+ * dirattr_get_... - retrieve various attributes
  */
 mode_t dirattr_get_mode(dah_t dah);
 uid_t dirattr_get_uid(dah_t dah);
@@ -68,17 +75,20 @@ uint32_t dirattr_get_projid(dah_t dah);
 uint32_t dirattr_get_dmevmask(dah_t dah);
 uint32_t dirattr_get_dmstate(dah_t dah);
 
-/* dirattr_flush - flush dirattr I/O buffer.  Returns 0 if successful.
+/*
+ * dirattr_flush - flush dirattr I/O buffer.  Returns 0 if successful.
  */
 extern rv_t dirattr_flush(void);
 
-/* dirattr_addextattr - record an extended attribute. second argument is
+/*
+ * dirattr_addextattr - record an extended attribute. second argument is
  * ptr to extattrhdr_t, with extattr name and value appended as
  * described by hdr.
  */
 extern void dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp);
 
-/* dirattr_cb_extattr - calls back for every extended attribute associated with
+/*
+ * dirattr_cb_extattr - calls back for every extended attribute associated with
  * the given dah. stops iteration and returnd FALSE if cbfunc returns FALSE,
  * else returns TRUE.
  */
diff --git a/restore/getopt.h b/restore/getopt.h
index b5bc004..10eab6b 100644
--- a/restore/getopt.h
+++ b/restore/getopt.h
@@ -18,7 +18,8 @@
 #ifndef GETOPT_H
 #define GETOPT_H
 
-/* getopt.h	common getopt  command string
+/*
+ * getopt.h	common getopt  command string
  *
  * several modules parse the command line looking for arguments specific to
  * that module. Unfortunately, each of the getopt(3) calls needs the
diff --git a/restore/inomap.c b/restore/inomap.c
index 44083ca..c8adf9b 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -48,18 +48,22 @@
 
 /* structure definitions used locally ****************************************/
 
-/* restores the inomap into a file
+/*
+ * restores the inomap into a file
  */
 #define PERS_NAME	"inomap"
 
-/* reserve the first page for persistent state
+/*
+ * reserve the first page for persistent state
  */
 struct pers {
 	size64_t hnkcnt;
-		/* number of hunks in map
+		/*
+		 * number of hunks in map
 		 */
 	size64_t segcnt;
-		/* number of segments
+		/*
+		 * number of segments
 		 */
 	xfs_ino_t last_ino_added;
 };
@@ -75,7 +79,8 @@ extern size_t pgsz;
 
 /* forward declarations of locally defined static functions ******************/
 
-/* inomap primitives
+/*
+ * inomap primitives
  */
 static int map_getset(xfs_ino_t, int, bool_t);
 static int map_set(xfs_ino_t ino, int);
@@ -87,10 +92,12 @@ static seg_t * map_getsegment(xfs_ino_t ino);
 /* definition of locally defined static variables *****************************/
 
 static int pers_fd = -1;
-	/* file descriptor for persistent inomap backing store
+	/*
+	 * file descriptor for persistent inomap backing store
 	 */
 
-/* context for inomap construction - initialized by inomap_restore_pers
+/*
+ * context for inomap construction - initialized by inomap_restore_pers
  */
 static uint64_t hnkcnt;
 static uint64_t segcnt;
@@ -99,7 +106,8 @@ static hnk_t *tailhnkp;
 static seg_t *lastsegp;
 static xfs_ino_t last_ino_added;
 
-/* map context and operators
+/*
+ * map context and operators
  */
 
 static inline void
@@ -199,19 +207,22 @@ inomap_restore_pers(drive_t *drivep,
 	int i;
 	bool_t ok;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(INOPERSEG == (sizeof(((seg_t *)0)->lobits) * NBBY));
 	assert(sizeof(hnk_t) == HNKSZ);
 	assert(sizeof(pers_t) <= PERSSZ);
 
-	/* get inomap info from media hdr
+	/*
+	 * get inomap info from media hdr
 	 */
 	hnkcnt = scrhdrp->cih_inomap_hnkcnt;
 	segcnt = scrhdrp->cih_inomap_segcnt;
 	last_ino_added = scrhdrp->cih_inomap_lastino;
 
-	/* truncate and open the backing store
+	/*
+	 * truncate and open the backing store
 	 */
 	perspath = open_pathalloc(hkdir, PERS_NAME, 0);
 	(void)unlink(perspath);
@@ -226,7 +237,8 @@ inomap_restore_pers(drive_t *drivep,
 		return RV_ERROR;
 	}
 
-	/* mmap the persistent hdr and space for the map
+	/*
+	 * mmap the persistent hdr and space for the map
 	 */
 	persp = (pers_t *) mmap_autogrow(
 				     PERSSZ
@@ -242,7 +254,8 @@ inomap_restore_pers(drive_t *drivep,
 		return RV_ERROR;
 	}
 
-	/* load the pers hdr
+	/*
+	 * load the pers hdr
 	 */
 	persp->hnkcnt = hnkcnt;
 	persp->segcnt = segcnt;
@@ -251,7 +264,8 @@ inomap_restore_pers(drive_t *drivep,
 	tmphnkp = (hnk_t *)calloc((size_t)hnkcnt, sizeof(hnk_t));
 	assert(tmphnkp);
 
-	/* read the map in from media
+	/*
+	 * read the map in from media
 	 */
 	nread = read_buf((char *)tmphnkp,
 			  sizeof(hnk_t) * (size_t)hnkcnt,
@@ -268,7 +282,8 @@ inomap_restore_pers(drive_t *drivep,
 
 	mlog(MLOG_NITTY, "inomap_restore_pers: pre-munmap\n");
 
-	/* close up
+	/*
+	 * close up
 	 */
 	rval1 = munmap((void *)persp,
 		        PERSSZ
@@ -280,7 +295,8 @@ inomap_restore_pers(drive_t *drivep,
 
 	mlog(MLOG_NITTY, "inomap_restore_pers: post-munmap\n");
 
-	/* check the return code from read
+	/*
+	 * check the return code from read
 	 */
 	switch (rval) {
 	case 0:
@@ -304,7 +320,8 @@ inomap_restore_pers(drive_t *drivep,
 	}
 }
 
-/* peels inomap from media
+/*
+ * peels inomap from media
  */
 rv_t
 inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp)
@@ -315,11 +332,13 @@ inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp)
 	int nread;
 	int rval;
 
-	/* get inomap info from media hdr
+	/*
+	 * get inomap info from media hdr
 	 */
 	tmphnkcnt = scrhdrp->cih_inomap_hnkcnt;
 
-	/* read the map in from media
+	/*
+	 * read the map in from media
 	 */
 	nread = read_buf(0,
 			  sizeof(hnk_t) * (size_t)tmphnkcnt,
@@ -327,7 +346,8 @@ inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp)
 			  (rfp_t)dop->do_read,
 			  (rrbfp_t)dop->do_return_read_buf,
 			  &rval);
-	/* check the return code from read
+	/*
+	 * check the return code from read
 	 */
 	switch (rval) {
 	case 0:
@@ -354,17 +374,20 @@ inomap_sync_pers(char *hkdir)
 	pers_t *persp;
 	hnk_t *hnkp;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(sizeof(hnk_t) == HNKSZ);
 
-	/* only needed once per session
+	/*
+	 * only needed once per session
 	 */
 	if (pers_fd >= 0) {
 		return BOOL_TRUE;
 	}
 
-	/* open the backing store. if not present, ok, hasn't been created yet
+	/*
+	 * open the backing store. if not present, ok, hasn't been created yet
 	 */
 	perspath = open_pathalloc(hkdir, PERS_NAME, 0);
 	pers_fd = open(perspath, O_RDWR);
@@ -372,7 +395,8 @@ inomap_sync_pers(char *hkdir)
 		return BOOL_TRUE;
 	}
 
-	/* mmap the persistent hdr
+	/*
+	 * mmap the persistent hdr
 	 */
 	persp = (pers_t *) mmap_autogrow(
 				     PERSSZ,
@@ -386,13 +410,15 @@ inomap_sync_pers(char *hkdir)
 		return BOOL_FALSE;
 	}
 
-	/* read the pers hdr
+	/*
+	 * read the pers hdr
 	 */
 	hnkcnt = persp->hnkcnt;
 	segcnt = persp->segcnt;
 	last_ino_added = persp->last_ino_added;
 
-	/* mmap the pers inomap
+	/*
+	 * mmap the pers inomap
 	 */
 	assert(hnkcnt * sizeof(hnk_t) <= (size64_t)INT32MAX);
 	roothnkp = (hnk_t *) mmap_autogrow(
@@ -407,7 +433,8 @@ inomap_sync_pers(char *hkdir)
 		return BOOL_FALSE;
 	}
 
-	/* correct the next pointers
+	/*
+	 * correct the next pointers
 	 */
 	for (hnkp = roothnkp
 	     ;
@@ -418,7 +445,8 @@ inomap_sync_pers(char *hkdir)
 	}
 	hnkp->nextp = 0;
 
-	/* calculate the tail pointers
+	/*
+	 * calculate the tail pointers
 	 */
 	tailhnkp = hnkp;
 	assert(hnkcnt > 0);
@@ -428,12 +456,14 @@ inomap_sync_pers(char *hkdir)
 						 -
 						 1)];
 
-	/* now all inomap operators will work
+	/*
+	 * now all inomap operators will work
 	 */
 	return BOOL_TRUE;
 }
 
-/* de-allocate the persistent inomap
+/*
+ * de-allocate the persistent inomap
  */
 void
 inomap_del_pers(char *hkdir)
@@ -443,7 +473,8 @@ inomap_del_pers(char *hkdir)
 	free((void *)perspath);
 }
 
-/* mark all included non-dirs as MAP_NDR_NOREST
+/*
+ * mark all included non-dirs as MAP_NDR_NOREST
  */
 void
 inomap_sanitize(void)
@@ -451,7 +482,8 @@ inomap_sanitize(void)
 	hnk_t *hnkp;
 	seg_t *segp;
 
-	/* step through all hunks, segs, and inos
+	/*
+	 * step through all hunks, segs, and inos
 	 */
 	for (hnkp = roothnkp
 	     ;
@@ -486,7 +518,8 @@ inomap_sanitize(void)
 	}
 }
 
-/* called to mark a non-dir ino as TO be restored
+/*
+ * called to mark a non-dir ino as TO be restored
  */
 void
 inomap_rst_add(xfs_ino_t ino)
@@ -495,7 +528,8 @@ inomap_rst_add(xfs_ino_t ino)
 		(void)map_set(ino, MAP_NDR_CHANGE);
 }
 
-/* called to mark a non-dir ino as NOT to be restored
+/*
+ * called to mark a non-dir ino as NOT to be restored
  */
 void
 inomap_rst_del(xfs_ino_t ino)
@@ -504,7 +538,8 @@ inomap_rst_del(xfs_ino_t ino)
 		(void)map_set(ino, MAP_NDR_NOREST);
 }
 
-/* called to ask if any inos in the given range need to be restored.
+/*
+ * called to ask if any inos in the given range need to be restored.
  * range is inclusive
  */
 bool_t
@@ -513,19 +548,22 @@ inomap_rst_needed(xfs_ino_t firstino, xfs_ino_t lastino)
 	hnk_t *hnkp;
 	seg_t *segp;
 
-	/* if inomap not restored/resynced, just say yes
+	/*
+	 * if inomap not restored/resynced, just say yes
 	 */
 	if (! roothnkp) {
 		return BOOL_TRUE;
 	}
 
-	/* may be completely out of range
+	/*
+	 * may be completely out of range
 	 */
 	if (firstino > last_ino_added) {
 		return BOOL_FALSE;
 	}
 
-	/* find the hunk/seg containing first ino or any ino beyond
+	/*
+	 * find the hunk/seg containing first ino or any ino beyond
 	 */
 	for (hnkp = roothnkp; hnkp != 0; hnkp = hnkp->nextp) {
 		if (firstino > hnkp->maxino) {
@@ -543,7 +581,8 @@ inomap_rst_needed(xfs_ino_t firstino, xfs_ino_t lastino)
 	return BOOL_FALSE;
 
 begin:
-	/* search until at least one ino is needed or until beyond last ino
+	/*
+	 * search until at least one ino is needed or until beyond last ino
 	 */
 	for (;;) {
 		xfs_ino_t ino;
@@ -579,7 +618,8 @@ begin:
 	/* NOTREACHED */
 }
 
-/* calls the callback for all inos with an inomap state included
+/*
+ * calls the callback for all inos with an inomap state included
  * in the state mask. stops iteration when inos exhaused or cb
  * returns FALSE.
  */
@@ -591,7 +631,8 @@ inomap_cbiter(int statemask,
 	hnk_t *hnkp;
 	seg_t *segp;
 
-	/* step through all hunks, segs, and inos
+	/*
+	 * step through all hunks, segs, and inos
 	 */
 	for (hnkp = roothnkp
 	     ;
@@ -631,7 +672,8 @@ inomap_cbiter(int statemask,
 
 /* definition of locally defined static functions ****************************/
 
-/* map_getset - locates and gets the state of the specified ino,
+/*
+ * map_getset - locates and gets the state of the specified ino,
  * and optionally sets the state to a new value.
  */
 static int
@@ -659,7 +701,8 @@ map_getsegment(xfs_ino_t ino)
 	uint64_t hnk;
 	uint64_t seg;
 
-	/* Use binary search to find the hunk that contains the inode number,
+	/*
+	 * Use binary search to find the hunk that contains the inode number,
 	 * if any.  This counts on the fact that all the hunks are contiguous
 	 * in memory and therefore can be treated as an array instead of a
 	 * list.
@@ -684,7 +727,8 @@ map_getsegment(xfs_ino_t ino)
 		return NULL;	/* inode number fell between hunks */
 	}
 
-	/* Use binary search to find the segment within the hunk that contains
+	/*
+	 * Use binary search to find the segment within the hunk that contains
 	 * the inode number, if any.
 	 */
 
diff --git a/restore/inomap.h b/restore/inomap.h
index 55f9d07..2211cb0 100644
--- a/restore/inomap.h
+++ b/restore/inomap.h
@@ -18,7 +18,8 @@
 #ifndef INOMAP_H
 #define INOMAP_H
 
-/* inomap.[hc] - inode map abstraction
+/*
+ * inomap.[hc] - inode map abstraction
  *
  * an inode map describes the inode numbers (inos) in a file system dump.
  * the map identifies which inos are in-use by the fs, which of those are
@@ -30,7 +31,8 @@
  * for each ino.
  */
 
-/* map state values
+/*
+ * map state values
  */
 #define MAP_INO_UNUSED	0       /* ino not in use by fs */
 #define MAP_DIR_NOCHNG	1       /* dir, ino in use by fs, but not dumped */
@@ -41,7 +43,8 @@
 #define MAP_NDR_NOREST	6       /* was MAP_NDR_CHANGE, but not to be restored */
 #define MAP_RESERVED2	7       /* this state currently not used */
 
-/* the inomap is implemented as a linked list of chunks. each chunk contains
+/*
+ * the inomap is implemented as a linked list of chunks. each chunk contains
  * an array of map segments. a map segment contains a start ino and a
  * bitmap of 64 3-bit state values (see MAP_... in inomap.h). the SEG_macros
  * index and manipulate the 3-bit state values.
diff --git a/restore/namreg.c b/restore/namreg.c
index b6c4724..5e99536 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -42,7 +42,8 @@
 
 #define NAMREG_AVGLEN	10
 
-/* persistent context for a namreg - placed in first page
+/*
+ * persistent context for a namreg - placed in first page
  * of the namreg file by namreg_init if not a sync
  */
 struct namreg_pers {
@@ -53,7 +54,8 @@ typedef struct namreg_pers namreg_pers_t;
 
 #define NAMREG_PERS_SZ	pgsz
 
-/* transient context for a namreg - allocated by namreg_init()
+/*
+ * transient context for a namreg - allocated by namreg_init()
  */
 
 #define	NAMREG_BUFSIZE	32768
@@ -72,7 +74,8 @@ typedef struct namreg_tran namreg_tran_t;
 
 #ifdef NAMREGCHK
 
-/* macros for manipulating namreg handles when handle consistency
+/*
+ * macros for manipulating namreg handles when handle consistency
  * checking is enabled.
  */
 #define CHKBITCNT		2
@@ -122,26 +125,31 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 		return BOOL_TRUE;
 	}
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(! ntp);
 	assert(! npp);
 
 	assert(sizeof(namreg_pers_t) <= NAMREG_PERS_SZ);
 
-	/* allocate and initialize context
+	/*
+	 * allocate and initialize context
 	 */
 	ntp = (namreg_tran_t *)calloc(1, sizeof(namreg_tran_t));
 	assert(ntp);
 
-	/* generate a string containing the pathname of the namreg file
+	/*
+	 * generate a string containing the pathname of the namreg file
 	 */
 	ntp->nt_pathname = open_pathalloc(hkdir, namregfile, 0);
 
-	/* open the namreg file
+	/*
+	 * open the namreg file
 	 */
 	if (resume) {
-		/* open existing file
+		/*
+		 * open existing file
 		 */
 		ntp->nt_fd = open(ntp->nt_pathname, O_RDWR);
 		if (ntp->nt_fd < 0) {
@@ -153,7 +161,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 			return BOOL_FALSE;
 		}
 	} else {
-		/* create the namreg file, first unlinking any older version
+		/*
+		 * create the namreg file, first unlinking any older version
 		 * laying around
 		 */
 		(void)unlink(ntp->nt_pathname);
@@ -169,7 +178,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 			return BOOL_FALSE;
 		}
 
-		/* reserve space for the backing store. try to use RESVSP64.
+		/*
+		 * reserve space for the backing store. try to use RESVSP64.
 		 * if doesn't work, try ALLOCSP64. the former is faster, as
 		 * it does not zero the space.
 		 */
@@ -227,7 +237,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 		}
 	}
 
-	/* mmap the persistent descriptor
+	/*
+	 * mmap the persistent descriptor
 	 */
 	assert(! (NAMREG_PERS_SZ % pgsz));
 	npp = (namreg_pers_t *) mmap_autogrow(
@@ -242,13 +253,15 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 		return BOOL_FALSE;
 	}
 
-	/* initialize persistent state
+	/*
+	 * initialize persistent state
 	 */
 	if (! resume) {
 		npp->np_appendoff = (off64_t)NAMREG_PERS_SZ;
 	}
 
-	/* initialize transient state
+	/*
+	 * initialize transient state
 	 */
 	ntp->nt_at_endpr = BOOL_FALSE;
 
@@ -262,13 +275,15 @@ namreg_add(char *name, size_t namelen)
 	unsigned char c;
 	nrh_t nrh;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(ntp);
 	assert(npp);
 	assert(!ntp->nt_map);
 
-	/* make sure file pointer is positioned to append
+	/*
+	 * make sure file pointer is positioned to append
 	 */
 	if (! ntp->nt_at_endpr) {
 		off64_t newoff;
@@ -290,17 +305,20 @@ namreg_add(char *name, size_t namelen)
 		}
 	}
 
-	/* save the current offset
+	/*
+	 * save the current offset
 	 */
 	oldoff = npp->np_appendoff;
 
-	/* write a one byte unsigned string length into the buffer.
+	/*
+	 * write a one byte unsigned string length into the buffer.
 	 */
 	assert(namelen < 256);
 	c = (unsigned char)(namelen & 0xff);
 	ntp->nt_buf[ntp->nt_off++] = c;
 
-	/* write the name string into the buffer.
+	/*
+	 * write the name string into the buffer.
 	 */
 	memcpy(ntp->nt_buf + ntp->nt_off, name, namelen);
 	ntp->nt_off += namelen;
@@ -310,7 +328,8 @@ namreg_add(char *name, size_t namelen)
 
 #ifdef NAMREGCHK
 
-	/* encode the lsb of the len plus the first character into the handle.
+	/*
+	 * encode the lsb of the len plus the first character into the handle.
 	 */
 	nrh = CHKMKHDL((nrh_t)namelen + (nrh_t)*name, (nrh_t)oldoff);
 
@@ -327,7 +346,8 @@ namreg_add(char *name, size_t namelen)
 void
 namreg_del(nrh_t nrh)
 {
-	/* currently not implemented - grows, never shrinks
+	/*
+	 * currently not implemented - grows, never shrinks
 	 */
 }
 
@@ -336,13 +356,15 @@ namreg_flush(void)
 {
 	ssize_t nwritten;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	*/
 	assert(ntp);
 
 	if (ntp->nt_off) {
 
-		/* write the accumulated name strings.
+		/*
+		 * write the accumulated name strings.
 		*/
 		nwritten = write(ntp->nt_fd, (void *)ntp->nt_buf, ntp->nt_off);
 		if (nwritten != ntp->nt_off) {
@@ -379,16 +401,19 @@ namreg_get(nrh_t nrh,
 	nrh_t chkbit;
 #endif /* NAMREGCHK */
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(ntp);
 	assert(npp);
 
-	/* make sure we aren't being given a NULL handle
+	/*
+	 * make sure we aren't being given a NULL handle
 	 */
 	assert(nrh != NRH_NULL);
 
-	/* convert the handle into the offset
+	/*
+	 * convert the handle into the offset
 	 */
 #ifdef NAMREGCHK
 
@@ -401,7 +426,8 @@ namreg_get(nrh_t nrh,
 
 #endif /* NAMREGCHK */
 
-	/* do sanity check on offset
+	/*
+	 * do sanity check on offset
 	 */
 	assert(newoff <= HDLMAX);
 	assert(newoff < npp->np_appendoff);
@@ -422,7 +448,8 @@ namreg_get(nrh_t nrh,
 			}
 		}
 
-		/* seek to the name
+		/*
+		 * seek to the name
 		*/
 		newoff = lseek64(ntp->nt_fd, newoff, SEEK_SET);
 		if (newoff == (off64_t)-1) {
@@ -434,7 +461,8 @@ namreg_get(nrh_t nrh,
 		}
 		ntp->nt_at_endpr = BOOL_FALSE;
 
-		/* read the name length and the name itself in one call
+		/*
+		 * read the name length and the name itself in one call
 		 * NOTE: assumes read_buf is big enough for the longest
 		 * allowed name (255 chars) plus one byte for length.
 		 */
@@ -451,7 +479,8 @@ namreg_get(nrh_t nrh,
 		in_bufp = read_buf;
 	}
 
-	/* deal with a short caller-supplied buffer
+	/*
+	 * deal with a short caller-supplied buffer
 	 */
 	len = (size_t)in_bufp[0];
 	if (bufsz < len + 1) {
@@ -459,13 +488,15 @@ namreg_get(nrh_t nrh,
 		return -1;
 	}
 
-	/* copy the name into the caller-supplied buffer.
+	/*
+	 * copy the name into the caller-supplied buffer.
 	 */
 	strncpy(bufp, in_bufp+1, len);
 
 #ifdef NAMREGCHK
 
-	/* validate the checkbit
+	/*
+	 * validate the checkbit
 	 */
 	assert(chkbit
 		==
@@ -473,7 +504,8 @@ namreg_get(nrh_t nrh,
 
 #endif /* NAMREGCHK */
 
-	/* null-terminate the string if room
+	/*
+	 * null-terminate the string if room
 	 */
 	bufp[len] = 0;
 
@@ -497,7 +529,8 @@ namreg_map(void)
 					ntp->nt_fd,
 					NAMREG_PERS_SZ);
 
-	/* it's okay if this fails, just fall back to (the much slower)
+	/*
+	 * it's okay if this fails, just fall back to (the much slower)
 	 * seek-and-read lookups.
 	 */
 	if (ntp->nt_map == (char *)-1) {
diff --git a/restore/namreg.h b/restore/namreg.h
index bd014e2..159dac3 100644
--- a/restore/namreg.h
+++ b/restore/namreg.h
@@ -18,19 +18,22 @@
 #ifndef NAMREG_H
 #define NAMREG_H
 
-/* namreg.[hc] - directory entry registry
+/*
+ * namreg.[hc] - directory entry registry
  *
  * provides unique directory entry ID's and storage for the entry
  * name.
  */
 
-/* nrh_t - handle to a registered name
+/*
+ * nrh_t - handle to a registered name
  */
 typedef size64_t nrh_t;
 #define NRH_NULL	SIZE64MAX
 
 
-/* namreg_init - creates the name registry. resync is TRUE if the
+/*
+ * namreg_init - creates the name registry. resync is TRUE if the
  * registry should already exist, and we are resynchronizing.
  * if NOT resync, inocnt hints at how many names will be held
  */
@@ -39,23 +42,27 @@ extern bool_t namreg_init(char *housekeepingdir,
 			   uint64_t inocnt);
 
 
-/* namreg_add - registers a name. name does not need to be null-terminated.
+/*
+ * namreg_add - registers a name. name does not need to be null-terminated.
  * returns handle for use with namreg_get().
  */
 extern nrh_t namreg_add(char *name, size_t namelen);
 
 
-/* namreg_del - remove a name from the registry
+/*
+ * namreg_del - remove a name from the registry
  */
 extern void namreg_del(nrh_t nrh);
 
-/* namreg_map - mmap the name registry, allowing for much
+/*
+ * namreg_map - mmap the name registry, allowing for much
  * faster namreg_get() lookups. once called, additional
  * entries cannot be added.
  */
 extern rv_t namreg_map(void);
 
-/* namreg_get - retrieves the name identified by the index.
+/*
+ * namreg_get - retrieves the name identified by the index.
  * fills the buffer with the null-terminated name from the registry.
  * returns the strlen() of the name. returns -1 if the buffer is too
  * small to fit the null-terminated name. return -2 if the name
diff --git a/restore/node.c b/restore/node.c
index b7f2b1b..423f4f6 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -38,11 +38,13 @@
 extern size_t pgsz;
 extern size_t pgmask;
 
-/* node handle limits
+/*
+ * node handle limits
  */
 #ifdef NODECHK
 
-/* macros for manipulating node handles when handle consistency
+/*
+ * macros for manipulating node handles when handle consistency
  * checking is enabled. the upper bits of a handle will be loaded
  * with the node gen count, described below. this should not be
  * used for production code, it cuts into the number of dirents
@@ -65,7 +67,8 @@ extern size_t pgmask;
 					  ((int)n & HDLMASK)))
 #define NH_MAX			(HDLMASK)
 
-/* the housekeeping byte of each node will hold two check fields:
+/*
+ * the housekeeping byte of each node will hold two check fields:
  * a gen count, initialized to 0 and incremented each time a node
  * is allocated, to catch re-use of stale handles; and unique pattern, to
  * differentiate a valid node from random memory. two unique patterns will
@@ -91,7 +94,8 @@ extern size_t pgmask;
 				    |					\
 				    ((int)u & HKPUNQMASK)))
 
-/* simple patterns for detecting a node
+/*
+ * simple patterns for detecting a node
  */
 #define NODEUNQFREE			0x9
 #define NODEUNQALCD			0x6
@@ -102,12 +106,14 @@ extern size_t pgmask;
 
 #endif /* NODECHK */
 
-/* window constraints
+/*
+ * window constraints
  */
 #define NODESPERSEG_MIN	1048576
 #define WINMAP_MIN	4
 
-/* reserve the firstpage for a header to save persistent context
+/*
+ * reserve the firstpage for a header to save persistent context
  */
 #define NODE_HDRSZ	pgsz
 
@@ -115,40 +121,51 @@ typedef int relnix_t;
 
 struct node_hdr {
 	size_t nh_nodesz;
-		/* internal node size - user may see something smaller
+		/*
+		 * internal node size - user may see something smaller
 		 */
 	ix_t nh_nodehkix;
-		/* index of byte in each node the user has reserved
+		/*
+		 * index of byte in each node the user has reserved
 		 * for use by me
 		 */
 	nh_t nh_nodesperseg;
-		/* an integral number of internal nodes must fit into a
+		/*
+		 * an integral number of internal nodes must fit into a
 		 * segment
 		 */
 	size64_t nh_segsz;
-		/* the backing store is partitoned into segment, which
+		/*
+		 * the backing store is partitoned into segment, which
 		 * can be mapped into VM windows  by the win abstraction
 		 */
 	size_t nh_winmapmax;
-		/* maximum number of windows which can be mapped
+		/*
+		 * maximum number of windows which can be mapped
 		 */
 	size_t nh_nodealignsz;
-		/* user's constraint on node alignment
+		/*
+		 * user's constraint on node alignment
 		 */
 	nh_t nh_freenh;
-		/* handle of first node of singly-linked list of free nodes
+		/*
+		 * handle of first node of singly-linked list of free nodes
 		 */
 	off64_t nh_firstsegoff;
-		/* offset into backing store of the first segment
+		/*
+		 * offset into backing store of the first segment
 		 */
 	nh_t nh_virgnh;
-		/* handle of next virgin node
+		/*
+		 * handle of next virgin node
 		 */
 	int nh_segixshift;
-		/* bitshift used to extract the segment index from an nh_t
+		/*
+		 * bitshift used to extract the segment index from an nh_t
 		 */
 	relnix_t nh_relnixmask;
-		/* bitmask used to extract the node index from an nh_t
+		/*
+		 * bitmask used to extract the node index from an nh_t
 		 * (relative to the start of a segment)
 		 */
 };
@@ -197,7 +214,8 @@ node_unmap_internal(nh_t nh, void **pp, bool_t freepr)
 	assert(*pp);
 	assert(nh != NH_NULL);
 
-	/* convert the handle into an index
+	/*
+	 * convert the handle into an index
 	 */
 #ifdef NODECHK
 	hdlgen = HDLGETGEN(nh);
@@ -220,7 +238,8 @@ node_unmap_internal(nh_t nh, void **pp, bool_t freepr)
 	}
 #endif /* NODECHK */
 
-	/* unmap the window containing the node
+	/*
+	 * unmap the window containing the node
 	 */
 	win_unmap(nh2segix(nh), pp); /* zeros *pp */
 }
@@ -243,7 +262,8 @@ node_init(int fd,
 	size_t segcount;
 	int segixshift;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(sizeof(node_hdr_t) <= NODE_HDRSZ);
 	assert(sizeof(nh_t) < sizeof(off64_t));
@@ -251,19 +271,23 @@ node_init(int fd,
 	assert(sizeof(nh_t) <= sizeof(relnix_t));
 	assert(nodehkix < usrnodesz);
 	assert(usrnodesz >= sizeof(char *) + 1);
-		/* so node is at least big enough to hold
+		/*
+		 * so node is at least big enough to hold
 		 * the free list linkage and the housekeeping byte
 		 */
 	assert(nodehkix > sizeof(char *));
-		/* since beginning of each node is used to
+		/*
+		 * since beginning of each node is used to
 		 * link it in the free list.
 		 */
 
-	/* adjust the user's node size to meet user's alignment constraint
+	/*
+	 * adjust the user's node size to meet user's alignment constraint
 	*/
 	nodesz = (usrnodesz + nodealignsz - 1) & ~(nodealignsz - 1);
 
-	/* Calculate the node table params based on the number of inodes in the
+	/*
+	 * Calculate the node table params based on the number of inodes in the
 	 * dump, since that's all we know. Ideally we'd base this on the number
 	 * of dirents in the dump instead as there's a node per dirent.
 	 *
@@ -298,7 +322,8 @@ node_init(int fd,
 		return BOOL_FALSE;
 	}
 
-	/* This is checked as nodes are allocated as well (remember that
+	/*
+	 * This is checked as nodes are allocated as well (remember that
 	 * dirs_nondirs_cnt may be less than the number of nodes/dirents).
 	 * Checking this here prevents potential overflow in the logic below.
 	 */
@@ -328,13 +353,15 @@ node_init(int fd,
 
 		segsz = nodesperseg * nodesz;
 
-		/* max number of segments that will fit in virtual memory,
+		/*
+		 * max number of segments that will fit in virtual memory,
 		 * capped at the max possible number of segments
 		 */
 		winmapmax = min(vmsz / segsz, max_segments);
 	}
 
-	/* map the abstraction header
+	/*
+	 * map the abstraction header
 	 */
 	assert((NODE_HDRSZ & pgmask) == 0);
 	assert(! (NODE_HDRSZ % pgsz));
@@ -352,7 +379,8 @@ node_init(int fd,
 	    return BOOL_FALSE;
 	}
 
-	/* initialize and save persistent context.
+	/*
+	 * initialize and save persistent context.
 	 */
 	node_hdrp->nh_nodesz = nodesz;
 	node_hdrp->nh_nodehkix = nodehkix;
@@ -366,18 +394,21 @@ node_init(int fd,
 	node_hdrp->nh_segixshift = segixshift;
 	node_hdrp->nh_relnixmask = nodesperseg - 1;
 
-	/* save transient context
+	/*
+	 * save transient context
 	 */
 	node_fd = fd;
 
-	/* initialize the window abstraction
+	/*
+	 * initialize the window abstraction
 	 */
 	win_init(fd,
 		  node_hdrp->nh_firstsegoff,
 		  segsz,
 		  winmapmax);
 
-	/* announce the results
+	/*
+	 * announce the results
 	 */
 	mlog(MLOG_DEBUG | MLOG_TREE,
 	      "node_init:"
@@ -397,11 +428,13 @@ node_init(int fd,
 bool_t
 node_sync(int fd, off64_t off)
 {
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(sizeof(node_hdr_t) <= NODE_HDRSZ);
 
-	/* map the abstraction header
+	/*
+	 * map the abstraction header
 	 */
 	assert((NODE_HDRSZ & pgmask) == 0);
 	assert(off <= (off64_t)OFF64MAX);
@@ -418,11 +451,13 @@ node_sync(int fd, off64_t off)
 		return BOOL_FALSE;
 	}
 
-	/* save transient context
+	/*
+	 * save transient context
 	 */
 	node_fd = fd;
 
-	/* initialize the window abstraction
+	/*
+	 * initialize the window abstraction
 	 */
 	win_init(fd,
 		  node_hdrp->nh_firstsegoff,
@@ -443,7 +478,8 @@ node_alloc(void)
 	u_char_t unq;
 #endif /* NODECHK */
 
-	/* if there's a node available on the free list, use it.
+	/*
+	 * if there's a node available on the free list, use it.
 	 * otherwise get the next one from the current virgin segment,
 	 * or allocate a new virgin segment if the current one is depleted.
 	 */
@@ -503,7 +539,8 @@ node_alloc(void)
 		nh = node_hdrp->nh_virgnh++;
 	}
 
-	/* build a handle for node
+	/*
+	 * build a handle for node
 	 */
 	if (nh > NH_MAX) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -538,7 +575,8 @@ node_map(nh_t nh)
 
 	assert(nh != NH_NULL);
 
-	/* convert the handle into an index
+	/*
+	 * convert the handle into an index
 	 */
 #ifdef NODECHK
 	hdlgen = HDLGETGEN(nh);
@@ -547,7 +585,8 @@ node_map(nh_t nh)
 
 	assert(nh <= NH_MAX);
 
-	/* map in
+	/*
+	 * map in
 	 */
 	p = 0; /* keep lint happy */
 	node_map_internal(nh, (void **)&p);
@@ -589,7 +628,8 @@ node_free(nh_t *nhp)
 	nh = *nhp;
 	assert(nh != NH_NULL);
 
-	/* convert the handle into an index
+	/*
+	 * convert the handle into an index
 	 */
 #ifdef NODECHK
 	hdlgen = HDLGETGEN(nh);
@@ -598,7 +638,8 @@ node_free(nh_t *nhp)
 
 	assert(nh <= NH_MAX);
 
-	/* map in
+	/*
+	 * map in
 	 */
 	p = (u_char_t *)node_map(nh);
 	if (p == NULL){
@@ -607,7 +648,8 @@ node_free(nh_t *nhp)
 	}
 
 #ifdef NODECHK
-	/* fix up unique field
+	/*
+	 * fix up unique field
 	 */
 	hkpp = p + node_hdrp->nh_nodehkix;
 	nodegen = HKPGETGEN(*hkpp);
@@ -618,17 +660,20 @@ node_free(nh_t *nhp)
 	*hkpp = HKPMKHKP(nodegen, NODEUNQFREE);
 #endif /* NODECHK */
 
-	/* put node on free list
+	/*
+	 * put node on free list
 	 */
 	linkagep = (nh_t *)p;
 	*linkagep = node_hdrp->nh_freenh;
 	node_hdrp->nh_freenh = nh;
 
-	/* map out
+	/*
+	 * map out
 	 */
 	node_unmap_internal(nh, (void **)&p, BOOL_TRUE);
 
-	/* invalidate caller's handle
+	/*
+	 * invalidate caller's handle
 	 */
 	*nhp = NH_NULL;
 }
diff --git a/restore/node.h b/restore/node.h
index 5b5efda..6faf8ad 100644
--- a/restore/node.h
+++ b/restore/node.h
@@ -18,7 +18,8 @@
 #ifndef NODE_H
 #define NODE_H
 
-/* node.[ch] - abstract pool of nodes
+/*
+ * node.[ch] - abstract pool of nodes
  *
  * operators alloc, free, map, and unmap nodes.
  */
@@ -26,7 +27,8 @@
 typedef size32_t nh_t;
 #define NH_NULL	SIZE32MAX
 
-/* node_init - creates a new node abstraction.
+/*
+ * node_init - creates a new node abstraction.
  * user reserves one byte per node for use by the node abstraction
  */
 extern bool_t node_init(int fd,		/* backing store */
@@ -37,26 +39,31 @@ extern bool_t node_init(int fd,		/* backing store */
 		         size64_t vmsz,		/* abstractions's share of VM */
 		         size64_t dir_nondir);	/* num of dirs + nondirs */
 
-/* node_sync - syncs up with existing node abstraction persistent state
+/*
+ * node_sync - syncs up with existing node abstraction persistent state
  */
 extern bool_t node_sync(int fd, off64_t off);
 
-/* node_alloc - allocates a node, returning a handle.
+/*
+ * node_alloc - allocates a node, returning a handle.
  * returns NULL handle if no space left.
  */
 extern nh_t node_alloc(void);
 
-/* node_map - returns a pointer to the node identified by the node handle.
+/*
+ * node_map - returns a pointer to the node identified by the node handle.
  * pointer remains valid until node_unmap called.
  */
 extern void *node_map(nh_t node_handle);
 
-/* node_unmap - unmaps the node.
+/*
+ * node_unmap - unmaps the node.
  * SIDE-EFFECT: sets *nodepp to 0.
  */
 extern void node_unmap(nh_t node_handle, void **nodepp);
 
-/* node_free - frees a previously allocated node.
+/*
+ * node_free - frees a previously allocated node.
  * SIDE-EFFECT: sets *node_handlep to NODE_HANDLE_NULL.
  */
 extern void node_free(nh_t *node_handlep);
diff --git a/restore/tree.c b/restore/tree.c
index 87e6be3..d2637ce 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -65,54 +65,68 @@
 
 /* structure definitions used locally ****************************************/
 
-/* name of persistent state file
+/*
+ * name of persistent state file
  */
 #define PERS_NAME	"tree"
 
-/* orphanage specifics. ino must be otherwise unused in the dump source fs.
+/*
+ * orphanage specifics. ino must be otherwise unused in the dump source fs.
  * zero works.
  */
 #define ORPH_INO	0
 #define ORPH_NAME	"orphanage"
 
 
-/* VM budgeting - give hash array one sixteenth, rest goes to node array
+/*
+ * VM budgeting - give hash array one sixteenth, rest goes to node array
  */
 #define HASHSZ_PERVM	16
 
-/* reserve the first page for persistent state
+/*
+ * reserve the first page for persistent state
  */
 struct treePersStorage {
 	xfs_ino_t p_rootino;
-		/* ino of root
+		/*
+		 * ino of root
 		 */
 	nh_t p_rooth;
-		/* handle of root node
+		/*
+		 * handle of root node
 		 */
 	nh_t p_orphh;
-		/* handle to orphanage node
+		/*
+		 * handle to orphanage node
 		 */
 	size64_t p_hashsz;
-		/* size of hash array (private to hash abstraction)
+		/*
+		 * size of hash array (private to hash abstraction)
 		 */
 	size_t p_hashmask;
-		/* hash mask (private to hash abstraction)
+		/*
+		 * hash mask (private to hash abstraction)
 		 */
 	bool_t p_ownerpr;
-		/* restore directory owner/group attributes
+		/*
+		 * restore directory owner/group attributes
 		 */
 	bool_t p_fullpr;
-		/* restoring a full level 0 non-resumed dump (can skip
+		/*
+		 * restoring a full level 0 non-resumed dump (can skip
 		 * some steps)
 		 */
 	bool_t p_ignoreorphpr;
-		/* set if positive subtree or interactive
+		/*
+		 * set if positive subtree or interactive
 		 */
 	bool_t p_restoredmpr;
-		/* restore DMI event settings
+		/*
+		 * restore DMI event settings
 		 */
 	bool_t p_truncategenpr;
-		/* truncate inode generation number (for compatibility
+		/*
+		 * truncate inode generation number (for compatibility
 		 * with xfsdump format 2 and earlier)
 		 */
 };
@@ -122,7 +136,8 @@ typedef struct treePersStorage treepers_t;
 #define PERSSZ	perssz
 
 
-/* interactive dialog transient state
+/*
+ * interactive dialog transient state
  */
 #define INTER_ARGMAX	10	/* max number of args to interactive cmds */
 struct inter {
@@ -134,47 +149,59 @@ struct inter {
 
 typedef struct inter inter_t;
 
-/* transient state
+/*
+ * transient state
  */
 struct tran {
 	bool_t t_toconlypr;
-		/* just display table of contents; don't restore files
+		/*
+		 * just display table of contents; don't restore files
 		 */
 	char *t_hkdir;
-		/* full absolute pathname of housekeeping directory
+		/*
+		 * full absolute pathname of housekeeping directory
 		 */
 	char *t_dstdir;
-		/* full absolute pathname of destination directory
+		/*
+		 * full absolute pathname of destination directory
 		 */
 	bool_t t_dstdirisxfspr;
-		/* destination directory is an xfs filesystem; xfs-specific
+		/*
+		 * destination directory is an xfs filesystem; xfs-specific
 		 * calls can be made when needed.
 		 */
 	char *t_orphdir;
-		/* full absolute pathname of orphanage directory
+		/*
+		 * full absolute pathname of orphanage directory
 		 */
 	char *t_hksubtree;
-		/* if non-NULL, is path of hkdir relative to dstdir.
+		/*
+		 * if non-NULL, is path of hkdir relative to dstdir.
 		 * don't restore there.
 		 */
 	int t_persfd;
-		/* file descriptor of the persistent state file
+		/*
+		 * file descriptor of the persistent state file
 		 */
 	nh_t *t_hashp;
-		/* pointer to mapped hash array (private to hash abstraction)
+		/*
+		 * pointer to mapped hash array (private to hash abstraction)
 		 */
 	char t_namebuf[NAME_MAX + 1];
-		/* to hold names temporarily retrieved from name registry
+		/*
+		 * to hold names temporarily retrieved from name registry
 		 */
 	inter_t t_inter;
-		/* context for interactive subtree selection
+		/*
+		 * context for interactive subtree selection
 		 */
 };
 
 typedef struct tran tran_t;
 
 
-/* node structure. each node represents a directory entry
+/*
+ * node structure. each node represents a directory entry
  */
 #define NODESZ	56
 
@@ -197,14 +224,17 @@ struct node {
 typedef struct node node_t;
 
 #define NF_REAL		(1 << 0)
-	/* set when the corresponding file/dir has been created in
+	/*
+	 * set when the corresponding file/dir has been created in
 	 * the restore destination.
 	 */
 #define NF_SUBTREE	(1 << 1)
-	/* marks nodes in the selected subtrees.
+	/*
+	 * marks nodes in the selected subtrees.
 	 */
 #define NF_REFED	(1 << 2)
-	/* indicates node is still referenced according to incremental/resumed
+	/*
+	 * indicates node is still referenced according to incremental/resumed
 	 * dump. used to detect dirents no longer used. prior to restoring
 	 * a dump session, this flag is cleared in all nodes. during the dirent
 	 * restoral, it is set. it may also be set during the adjustment
@@ -212,15 +242,18 @@ typedef struct node node_t;
 	 * orphanage NEVER have this flag set.
 	 */
 #define NF_WRITTEN	(1 << 3)
-	/* set as soon as a non-dir node restore is begun. allows
+	/*
+	 * set as soon as a non-dir node restore is begun. allows
 	 * overwrite inhibit options to work with segmented files
 	 */
 #define NF_ISDIR	(1 << 4)
-	/* indicates this node is a directory. set when a directory is taken
+	/*
+	 * indicates this node is a directory. set when a directory is taken
 	 * from the dirdump.
 	 */
 #define NF_DUMPEDDIR	(1 << 5)
-	/* indicates this node is a directory present in the current dirdump.
+	/*
+	 * indicates this node is a directory present in the current dirdump.
 	 * at beginning of session, this flag is cleared in all nodes.
 	 * then as each directory dump is read from media, the flag
 	 * is set from the corresponding node. this allows adjustments to
@@ -230,7 +263,8 @@ typedef struct node node_t;
 	 * are referenced as well.
 	 */
 #define NF_NEWORPH	(1 << 6)
-	/* cleared from all nodes in the orphanage before a dump is applied.
+	/*
+	 * cleared from all nodes in the orphanage before a dump is applied.
 	 * set if a dir is seen in the dirdump but no node exists for it.
 	 * cleared if that dir is adopted subsequently during the dirdump.
 	 * set if a nondir is seen in the nondir dump but no node exists for
@@ -240,7 +274,8 @@ typedef struct node node_t;
 	 * old orphans had better be adopted, otherwise they will be unlinked.
 	 */
 
-/* link list iterator context
+/*
+ * link list iterator context
  */
 struct link_iter_context {
 	nh_t li_headh;          /* head of hard link list */
@@ -250,7 +285,8 @@ struct link_iter_context {
 };
 typedef struct link_iter_context link_iter_context_t;
 
-/* used for caching parent pathname from previous Node2path result
+/*
+ * used for caching parent pathname from previous Node2path result
  */
 struct path_cache {
 	nh_t nh;
@@ -366,7 +402,8 @@ tree_init(char *hkdir,
 	bool_t ok;
 	int rval;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(! (PERSSZ % pgsz));
 	assert(sizeof(persp) <= PERSSZ);
@@ -374,7 +411,8 @@ tree_init(char *hkdir,
 	assert(! persp);
 	assert(! tranp);
 
-	/* allocate transient state
+	/*
+	 * allocate transient state
 	 */
 	tranp = (tran_t *)calloc(1, sizeof(tran_t));
 	assert(tranp);
@@ -384,14 +422,16 @@ tree_init(char *hkdir,
 	tranp->t_dstdir = dstdir;
 	tranp->t_dstdirisxfspr = dstdirisxfspr;
 
-	/* allocate a char string buffer to hold the abs. pathname
+	/*
+	 * allocate a char string buffer to hold the abs. pathname
 	 * of the orphanage directory file. load it with the pathname.
 	 */
 	tranp->t_orphdir = open_pathalloc(tranp->t_dstdir,
 					   orphname,
 					   0);
 
-	/* determine if housekeeping dir is within the destination.
+	/*
+	 * determine if housekeeping dir is within the destination.
 	 * generate a relative path containing the difference,
 	 * else null. will not restore into there.
 	 */
@@ -401,7 +441,8 @@ tree_init(char *hkdir,
 		tranp->t_hksubtree = 0;
 	}
 
-	/* create an orphanage, if it already exists, complain.
+	/*
+	 * create an orphanage, if it already exists, complain.
 	 * not needed if just a table-of-contents restore.
 	 */
 	if (! tranp->t_toconlypr) {
@@ -422,11 +463,13 @@ tree_init(char *hkdir,
 		}
 	}
 
-	/* build a full pathname to pers. state file
+	/*
+	 * build a full pathname to pers. state file
 	 */
 	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
 
-	/* create the persistent state file
+	/*
+	 * create the persistent state file
 	 */
 	(void)unlink(perspath);
 	tranp->t_persfd = open(perspath,
@@ -440,7 +483,8 @@ tree_init(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* mmap the persistent state
+	/*
+	 * mmap the persistent state
 	 */
 	assert(! (PERSSZ % pgsz));
 	persp = (treepers_t *) mmap_autogrow(
@@ -455,7 +499,8 @@ tree_init(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* create the hash abstraction. it will map more of the
+	/*
+	 * create the hash abstraction. it will map more of the
 	 * persistent state file.
 	 */
 	ok = hash_init(vmsz / HASHSZ_PERVM, dircnt, nondircnt, perspath);
@@ -463,7 +508,8 @@ tree_init(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* initialize the node abstraction. let it's use of backing store
+	/*
+	 * initialize the node abstraction. let it's use of backing store
 	 * begin immediately after the hash abstraction. give it the remainder
 	 * of vm.
 	 */
@@ -481,7 +527,8 @@ tree_init(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* extract the root ino and allocate a node for
+	/*
+	 * extract the root ino and allocate a node for
 	 * the root and for the orphanage. place both nodes
 	 * in the hash list. make the orphanage a child of
 	 * root, and indicate he is real.
@@ -508,19 +555,23 @@ tree_init(char *hkdir,
 	link_in(persp->p_orphh);
 	adopt(persp->p_rooth, persp->p_orphh, NRH_NULL);
 
-	/* record if we should attempt to restore original owner/group
+	/*
+	 * record if we should attempt to restore original owner/group
 	 */
 	persp->p_ownerpr = ownerpr;
 
-	/* record if this is a full dump. can skip link processing if so
+	/*
+	 * record if this is a full dump. can skip link processing if so
 	 */
 	persp->p_fullpr = fullpr;
 
-	/* record if DMI event settings should be restored
+	/*
+	 * record if DMI event settings should be restored
 	 */
 	persp->p_restoredmpr = restoredmpr;
 
-	/* record if truncated generation numbers are required
+	/*
+	 * record if truncated generation numbers are required
 	 */
 	if (dumpformat < GLOBAL_HDR_VERSION_3) {
 		persp->p_truncategenpr = BOOL_TRUE;
@@ -554,7 +605,8 @@ tree_sync(char *hkdir,
 		return BOOL_TRUE;
 	}
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(! (PERSSZ % pgsz));
 	assert(sizeof(persp) <= PERSSZ);
@@ -562,7 +614,8 @@ tree_sync(char *hkdir,
 	assert(! persp);
 	assert(! tranp);
 
-	/* allocate transient state
+	/*
+	 * allocate transient state
 	 */
 	tranp = (tran_t *)calloc(1, sizeof(tran_t));
 	assert(tranp);
@@ -572,14 +625,16 @@ tree_sync(char *hkdir,
 	tranp->t_dstdir = dstdir;
 	tranp->t_dstdirisxfspr = dstdirisxfspr;
 
-	/* allocate a char string buffer to hold the abs. pathname
+	/*
+	 * allocate a char string buffer to hold the abs. pathname
 	 * of the orphanage directory file. load it with the pathname.
 	 */
 	tranp->t_orphdir = open_pathalloc(tranp->t_dstdir,
 					   orphname,
 					   0);
 
-	/* determine if housekeeping dir is within the destination.
+	/*
+	 * determine if housekeeping dir is within the destination.
 	 * generate a relative path containing the difference,
 	 * else null. will not restore into there.
 	 */
@@ -589,7 +644,8 @@ tree_sync(char *hkdir,
 		tranp->t_hksubtree = 0;
 	}
 
-	/* re-create the orphanage (in case someone rmdir'ed it)
+	/*
+	 * re-create the orphanage (in case someone rmdir'ed it)
 	 */
 	rval = mkdir(tranp->t_orphdir, S_IRWXU);
 	if (rval && errno != EEXIST) {
@@ -600,11 +656,13 @@ tree_sync(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* build a full pathname to pers. state file
+	/*
+	 * build a full pathname to pers. state file
 	 */
 	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
 
-	/* re-open the persistent state file
+	/*
+	 * re-open the persistent state file
 	 */
 	tranp->t_persfd = open(perspath, O_RDWR);
 	if (tranp->t_persfd < 0) {
@@ -615,7 +673,8 @@ tree_sync(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* mmap the persistent state
+	/*
+	 * mmap the persistent state
 	 */
 	assert(! (PERSSZ % pgsz));
 	persp = (treepers_t *) mmap_autogrow(
@@ -630,12 +689,14 @@ tree_sync(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* update the fullpr field of the persistent state to match
+	/*
+	 * update the fullpr field of the persistent state to match
 	 * the input of our caller.
 	 */
 	persp->p_fullpr = fullpr;
 
-	/* regardless of the format of this dump, if the previously applied
+	/*
+	 * regardless of the format of this dump, if the previously applied
 	 * dump used truncated generation numbers, then we need to as well.
 	 */
 	if (persp->p_truncategenpr) {
@@ -644,7 +705,8 @@ tree_sync(char *hkdir,
 		      "compatibility with previously applied restore\n"));
 	}
 
-	/* rsynchronize with the hash abstraction. it will map more of the
+	/*
+	 * rsynchronize with the hash abstraction. it will map more of the
 	 * persistent state file.
 	 */
 	ok = hash_sync(perspath);
@@ -652,7 +714,8 @@ tree_sync(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* synchronize with the node abstraction.
+	/*
+	 * synchronize with the node abstraction.
 	 */
 	assert(persp->p_hashsz <= (size64_t)(OFF64MAX - (off64_t)PERSSZ));
 	nodeoff = (off64_t)PERSSZ + (off64_t)persp->p_hashsz;
@@ -661,7 +724,8 @@ tree_sync(char *hkdir,
 		return BOOL_FALSE;
 	}
 
-	/* extract the root ino and allocate a node for
+	/*
+	 * extract the root ino and allocate a node for
 	 * the root and for the orphanage. place both nodes
 	 * in the hash list. make the orphanage a child of
 	 * root, and indicate he is real.
@@ -687,7 +751,8 @@ tree_check_dump_format(uint32_t dumpformat)
 	return BOOL_TRUE;
 }
 
-/* recursively descend the tree clearing REFED and DIRDUMPED and NEWORPH
+/*
+ * recursively descend the tree clearing REFED and DIRDUMPED and NEWORPH
  * flags. force the orphanage to be refed and dumped, so we won't try
  * to orphan it, and so things added to it won't look like they are
  * referenced during ref adj. also null dirattr handles, since they are
@@ -755,22 +820,26 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 		gen = BIGGEN2GEN(gen);
 	}
 
-	/* sanity check - orphino is supposed to be an unused ino!
+	/*
+	 * sanity check - orphino is supposed to be an unused ino!
 	 */
 	assert(ino != orphino);
 
-	/* lookup head of hardlink list
+	/*
+	 * lookup head of hardlink list
 	 */
 	hardh = link_hardh(ino, gen);
 	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
 
-	/* already present
+	/*
+	 * already present
 	 */
 	if (hardh != NH_NULL) {
 		node_t *hardp;
 		hardp = Node_map(hardh);
 		if (! (hardp->n_flags & NF_ISDIR)) {
-			/* case 1: previously seen as dirent, now know is dir
+			/*
+			 * case 1: previously seen as dirent, now know is dir
 			 */
 			mlog(MLOG_TRACE | MLOG_TREE,
 			      "directory %llu %u (%u): "
@@ -783,7 +852,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 				hardp->n_dah = dirattr_add(fhdrp);
 			}
 		} else if (! tranp->t_toconlypr && hardp->n_dah == DAH_NULL) {
-			/* case 2: node is a dir, but had thrown away dirattr
+			/*
+			 * case 2: node is a dir, but had thrown away dirattr
 			 */
 			mlog(MLOG_TRACE | MLOG_TREE,
 			      "directory %llu %u (%u): "
@@ -793,7 +863,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 			      fhdrp->fh_stat.bs_gen);
 			hardp->n_dah = dirattr_add(fhdrp);
 		} else {
-			/* case 3: already has dirattr; must be restart
+			/*
+			 * case 3: already has dirattr; must be restart
 			 */
 			mlog(MLOG_TRACE | MLOG_TREE,
 			      "directory %llu %u (%u): "
@@ -807,7 +878,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 		*dahp = hardp->n_dah;
 		Node_unmap(hardh, &hardp);
 	} else {
-		/* case 4: first time seen
+		/*
+		 * case 4: first time seen
 		 */
 		mlog(MLOG_TRACE | MLOG_TREE,
 		      "directory %llu %u (%u): "
@@ -844,11 +916,13 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 		gen = BIGGEN2GEN(gen);
 	}
 
-	/* sanity check - orphino is supposed to be an unused ino!
+	/*
+	 * sanity check - orphino is supposed to be an unused ino!
 	 */
 	assert(ino != orphino);
 
-	/* don't allow entries named "orphanage" under root to be added
+	/*
+	 * don't allow entries named "orphanage" under root to be added
 	 */
 	if (parh == persp->p_rooth && !strcmp(name, orphname)) {
 		mlog(MLOG_DEBUG | MLOG_TREE,
@@ -860,7 +934,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 		return RV_OK;
 	}
 
-	/* if the parent is null, just ignore
+	/*
+	 * if the parent is null, just ignore
 	 */
 	if (parh == NH_NULL) {
 		mlog(MLOG_DEBUG | MLOG_TREE,
@@ -872,7 +947,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 		return RV_OK;
 	}
 
-	/* see if one or more links to this ino already exist.
+	/*
+	 * see if one or more links to this ino already exist.
 	 */
 	hardh = link_hardh(ino, gen);
 
@@ -887,7 +963,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 
 			hardp->n_flags |= NF_REFED;
 			if (hardp->n_parh == persp->p_orphh) {
-				/* dir now seen as entry
+				/*
+				 * dir now seen as entry
 				 * if in orph but REAL, must be pending rename
 				 */
 				if ((hardp->n_flags & NF_REAL)
@@ -985,10 +1062,12 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 				if (hardp->n_parh == parh
 				     &&
 				     ! strcmp(tranp->t_namebuf, name)) {
-					/* dir seen as entry again
+					/*
+					 * dir seen as entry again
 					 */
 					if (hardp->n_lnkh != NH_NULL) {
-						/* rescind rename
+						/*
+						 * rescind rename
 						 */
 						mlog(MLOG_DEBUG | MLOG_TREE,
 						      "dirent %s %llu %u: "
@@ -1006,7 +1085,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 						      gen);
 					}
 				} else {
-					/* dir rename
+					/*
+					 * dir rename
 					 */
 					nh_t renameh;
 					node_t *renamep;
@@ -1040,7 +1120,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 					renamep = Node_map(renameh);
 					assert(hardp->n_parh != NH_NULL);
 					if (hardp->n_parh != parh) {
-						/* different parent
+						/*
+						 * different parent
 						 */
 						renamep->n_parh = parh;
 						mlog(MLOG_DEBUG | MLOG_TREE,
@@ -1051,7 +1132,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 						      gen);
 					}
 					if (strcmp(tranp->t_namebuf, name)) {
-						/* different name
+						/*
+						 * different name
 						 */
 						renamep->n_nrh =
 						    namreg_add(name, namelen);
@@ -1069,7 +1151,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 			nh_t matchh;
 			matchh = link_matchh(hardh, parh, name);
 			if (matchh != NH_NULL) {
-				/* entry already exists
+				/*
+				 * entry already exists
 				 */
 				node_t *matchp;
 				matchp = Node_map(matchh);
@@ -1082,7 +1165,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 				      ino,
 				      gen);
 			} else {
-				/* case 5: new hard link
+				/*
+				 * case 5: new hard link
 				 */
 				nrh_t nrh;
 				nh_t linkh;
@@ -1106,7 +1190,8 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 		}
 		Node_unmap(hardh, &hardp);
 	} else {
-		/* case 6: new entry
+		/*
+		 * case 6: new entry
 		 */
 		nrh_t nrh;
 		nrh = namreg_add(name, namelen);
@@ -1146,7 +1231,8 @@ tree_subtree_parse(bool_t sensepr, char *path)
 	bool_t isselpr;
 	bool_t ok;
 
-	/* walk the tree down this relative pathname from the root.
+	/*
+	 * walk the tree down this relative pathname from the root.
 	 */
 	ok = tsi_walkpath(path,
 			   NH_NULL,
@@ -1163,7 +1249,8 @@ tree_subtree_parse(bool_t sensepr, char *path)
 		return BOOL_FALSE;
 	}
 
-	/* set or clear flag in this node and all of its children,
+	/*
+	 * set or clear flag in this node and all of its children,
 	 * and ajust parentage flags.
 	 */
 	selsubtree(namedh, sensepr);
@@ -1171,7 +1258,8 @@ tree_subtree_parse(bool_t sensepr, char *path)
 	return BOOL_TRUE;
 }
 
-/* tree_post - called after the dirdump has been applied.
+/*
+ * tree_post - called after the dirdump has been applied.
  * first phase is to eliminate all unreferenced dirents.
  * done by recursive depth-wise descent of the tree. on the way
  * up, unlink or orphan unreferenced nondirs, unlink unreferenced
@@ -1210,7 +1298,8 @@ tree_post(char *path1, char *path2)
 	nh_t cldh;
 	bool_t ok;
 
-	/* eliminate unreferenced dirents
+	/*
+	 * eliminate unreferenced dirents
 	 */
 	if (! persp->p_fullpr) {
 		mlog(MLOG_DEBUG | MLOG_TREE,
@@ -1228,7 +1317,8 @@ tree_post(char *path1, char *path2)
 		}
 	}
 
-	/* make new directories
+	/*
+	 * make new directories
 	 */
 	mlog(MLOG_DEBUG | MLOG_TREE,
 	      "making new directories\n");
@@ -1244,7 +1334,8 @@ tree_post(char *path1, char *path2)
 	assert(tree_chk());
 #endif /* TREE_CHK */
 
-	/* rename directories
+	/*
+	 * rename directories
 	 */
 	if (! persp->p_fullpr) {
 		mlog(MLOG_DEBUG | MLOG_TREE,
@@ -1262,7 +1353,8 @@ tree_post(char *path1, char *path2)
 	assert(tree_chk());
 #endif /* TREE_CHK */
 
-	/* process hard links
+	/*
+	 * process hard links
 	 */
 	if (! persp->p_fullpr) {
 		mlog(MLOG_DEBUG | MLOG_TREE,
@@ -1436,7 +1528,8 @@ noref_elim_recurse(nh_t parh,
 				Node_unmap(cldh, &cldp);
 			}
 		} else  {
-			/* determine if we can unlink this node.
+			/*
+			 * determine if we can unlink this node.
 			 * if its not real, and not refed, simple.
 			 * if real and not refed and there is at least
 			 * one unreal refed node and no other real
@@ -1460,7 +1553,8 @@ noref_elim_recurse(nh_t parh,
 				assert(hardh != NH_NULL);
 				canunlinkpr = BOOL_FALSE;
 				neededpr = BOOL_FALSE;
-				/* tes@sgi.com:
+				/*
+				 * tes@sgi.com:
 				 * This loop seems to assume that
 				 * REAL files come before NON-REALs
 				 * so that we will break out first
@@ -1580,7 +1674,8 @@ noref_elim_recurse(nh_t parh,
 			}
 		}
 
-		/* next!
+		/*
+		 * next!
 		 */
 		cldh = nextcldh;
 	}
@@ -1610,7 +1705,8 @@ mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
 		nextcldh = cldp->n_sibh;
 		Node_unmap(cldh, &cldp);
 
-		/* if needed, create a directory and update real flag
+		/*
+		 * if needed, create a directory and update real flag
 		 */
 		if (isdirpr && ! isrealpr && isrefpr && isselpr) {
 			int rval;
@@ -1641,7 +1737,8 @@ mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
 			}
 		}
 
-		/* if a real selected directory, recurse
+		/*
+		 * if a real selected directory, recurse
 		 */
 		if (isdirpr && isrealpr && isselpr) {
 			bool_t ok;
@@ -1652,7 +1749,8 @@ mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
 			}
 		}
 
-		/* next!
+		/*
+		 * next!
 		 */
 		cldh = nextcldh;
 	}
@@ -1740,7 +1838,8 @@ rename_dirs(nh_t cldh,
 			Node_free(&renameh);
 		}
 
-		/* next!
+		/*
+		 * next!
 		 */
 		cldh = nextcldh;
 	}
@@ -1748,7 +1847,8 @@ rename_dirs(nh_t cldh,
 	return BOOL_TRUE;
 }
 
-/* will call funcp for all links to be created. will abort if funcp
+/*
+ * will call funcp for all links to be created. will abort if funcp
  * ever returns FALSE;
  */
 rv_t
@@ -1774,11 +1874,13 @@ tree_cb_links(xfs_ino_t ino,
 		gen = BIGGEN2GEN(gen);
 	}
 
-	/* find the hardhead
+	/*
+	 * find the hardhead
 	 */
 	hardh = link_hardh(ino, gen);
 
-	/* loop through all hard links, attempting to restore/link
+	/*
+	 * loop through all hard links, attempting to restore/link
 	 */
 	path = path1;
 	for (nh = hardh; nh != NH_NULL; nh = link_nexth(nh)) {
@@ -1786,20 +1888,23 @@ tree_cb_links(xfs_ino_t ino,
 		u_char_t flags;
 		char *reasonstr;
 
-		/* get the node flags
+		/*
+		 * get the node flags
 		 */
 		np = Node_map(nh);
 		flags = np->n_flags;
 		Node_unmap(nh, &np);
 
-		/* build a pathname
+		/*
+		 * build a pathname
 		 */
 		ok = Node2path(nh, path, _("restore"));
 		if (! ok) {
 			continue;
 		}
 
-		/* skip if not in selected subtree
+		/*
+		 * skip if not in selected subtree
 		 */
 		if (! (flags & NF_SUBTREE)) {
 			mlog((MLOG_NITTY + 1) | MLOG_TREE,
@@ -1811,7 +1916,8 @@ tree_cb_links(xfs_ino_t ino,
 			continue;
 		}
 
-		/* don't restore into the housekeeping directory
+		/*
+		 * don't restore into the housekeeping directory
 		 */
 		if (path_beginswith(path, tranp->t_hkdir)) {
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
@@ -1824,7 +1930,8 @@ tree_cb_links(xfs_ino_t ino,
 			continue;
 		}
 
-		/* check if ok to overwrite: don't check if we've already
+		/*
+		 * check if ok to overwrite: don't check if we've already
 		 * been here and decided overwrite ok. if ok, set flag
 		 * so we won't check again. in fact, can't check again
 		 * since restore changes the answer.
@@ -1871,7 +1978,8 @@ tree_cb_links(xfs_ino_t ino,
 			}
 		}
 
-		/* call callback to restore file / create hard link.
+		/*
+		 * call callback to restore file / create hard link.
 		 * returns !ok if should abort.
 		 */
 		if (path == path2) {
@@ -1893,19 +2001,22 @@ tree_cb_links(xfs_ino_t ino,
 			return RV_NOTOK;
 		}
 
-		/* set flag, indicating node is now real
+		/*
+		 * set flag, indicating node is now real
 		 */
 		np = Node_map(nh);
 		np->n_flags |= NF_REAL;
 		Node_unmap(nh, &np);
 
-		/* switch to second path buffer, for link paths
+		/*
+		 * switch to second path buffer, for link paths
 		 */
 		path = path2;
 	}
 
 
-	/* if not yet peeled from tape, do so: place in orphanage if
+	/*
+	 * if not yet peeled from tape, do so: place in orphanage if
 	 * no references found (i.e., hard link list empty).
 	 */
 	if (path == path1) {
@@ -1992,7 +2103,8 @@ tree_cb_links(xfs_ino_t ino,
 	return RV_OK;
 }
 
-/* uses flags cleared during directory restore (NF_DUMPEDDIR and NF_REFED)
+/*
+ * uses flags cleared during directory restore (NF_DUMPEDDIR and NF_REFED)
  * to determine what directory entries are no longer needed. this can
  * be done because whenever a directory chenges, it and all of its current
  * entries are dumped. so if an entry is dumped which is a dir, but that
@@ -2078,7 +2190,8 @@ tree_extattr_recurse(nh_t parh,
 	dah_t dah;
 	bool_t ok;
 
-	/* first update all children
+	/*
+	 * first update all children
 	 */
 	while (cldh != NH_NULL) {
 		node_t *cldp;
@@ -2096,7 +2209,8 @@ tree_extattr_recurse(nh_t parh,
 		nextcldh = cldp->n_sibh;
 		Node_unmap(cldh, &cldp);
 
-		/* if a real selected directory, recurse
+		/*
+		 * if a real selected directory, recurse
 		 */
 		if (isdirpr && isrealpr && isselpr) {
 			bool_t ok;
@@ -2110,12 +2224,14 @@ tree_extattr_recurse(nh_t parh,
 			}
 		}
 
-		/* next!
+		/*
+		 * next!
 		 */
 		cldh = nextcldh;
 	}
 
-	/* now update self
+	/*
+	 * now update self
 	 */
 	parp = Node_map(parh);
 	dah = parp->n_dah;
@@ -2150,7 +2266,8 @@ proc_hardlinks(char *path1, char *path2)
 {
 	phcb_t phcb;
 
-	/* have callback invoked for all hardheads
+	/*
+	 * have callback invoked for all hardheads
 	 */
 	phcb.path1 = path1;
 	phcb.path2 = path2;
@@ -2159,7 +2276,8 @@ proc_hardlinks(char *path1, char *path2)
 	return phcb.ok;
 }
 
-/* called for every hard head
+/*
+ * called for every hard head
  *
  * tes@sgi.com:
  * This code processes the hardlinks, extracting out a
@@ -2194,7 +2312,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 	bool_t ok;
 	int rval;
 
-	/* skip directories
+	/*
+	 * skip directories
 	 */
 	hardheadp = Node_map(hardheadh);
 	ino = hardheadp->n_ino;
@@ -2210,7 +2329,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 	      ino,
 	      gen);
 
-	/* first pass through hard link list: for each node, leave on
+	/*
+	 * first pass through hard link list: for each node, leave on
 	 * list, unlink and place on rename src list, unlink and place on
 	 * rename dst list, or unlink and discard. note a node available
 	 * to link from, in case we need it.
@@ -2226,7 +2346,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		bool_t isrefpr = np->n_flags & NF_REFED;
 		bool_t isselpr = np->n_flags & NF_SUBTREE;
 
-		/* if unrefed, unreal, free node etc. (sel doesn't matter)
+		/*
+		 * if unrefed, unreal, free node etc. (sel doesn't matter)
 		 */
 		if (! isrealpr && ! isrefpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
@@ -2239,7 +2360,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 			continue;
 		}
 
-		/* not real, refed, but not selected, can't help
+		/*
+		 * not real, refed, but not selected, can't help
 		 */
 		if (! isrealpr &&   isrefpr && ! isselpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
@@ -2249,7 +2371,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 			continue;
 		}
 
-		/* if unreal, refed, sel, add to dst list,
+		/*
+		 * if unreal, refed, sel, add to dst list,
 		 */
 		if (! isrealpr &&   isrefpr &&   isselpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
@@ -2263,7 +2386,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 			continue;
 		}
 
-		/* if real, unrefed, sel, add to src list
+		/*
+		 * if real, unrefed, sel, add to src list
 		 */
 		if (isrealpr && ! isrefpr &&   isselpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
@@ -2276,7 +2400,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 			continue;
 		}
 
-		/* would like to get rid of but not selected, or
+		/*
+		 * would like to get rid of but not selected, or
 		 * real and referenced, leave alone (sel doesn't matter).
 		 * consider as a lnk src, since real and not going away.
 		 */
@@ -2297,7 +2422,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		assert(0);
 	}
 
-	/* now pass through dst list, doing renames if src list not empty,
+	/*
+	 * now pass through dst list, doing renames if src list not empty,
 	 * otherwise links if a lnk src available, otherwise put back in link
 	 * list
 	 */
@@ -2312,7 +2438,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		dstp->n_lnkh = NH_NULL;
 		Node_unmap(dsth, &dstp);
 
-		/* build pathname to dst
+		/*
+		 * build pathname to dst
 		 */
 		ok = Node2path(dsth, phcbp->path2, _("rename to"));
 		if (! ok) {
@@ -2332,7 +2459,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 			srcp->n_lnkh = NH_NULL;
 			Node_unmap(srch, &srcp);
 
-			/* build a path to src
+			/*
+			 * build a path to src
 			 */
 			ok = Node2path(srch, phcbp->path1, _("rename from"));
 			if (! ok) {
@@ -2370,7 +2498,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 			successpr = BOOL_TRUE;
 		}
 
-		/* tes@sgi.com: note: loop of one iteration only
+		/*
+		 * tes@sgi.com: note: loop of one iteration only
 		 */
 		while (! successpr && lnsrch != NH_NULL) {
 			ok = Node2path(lnsrch, phcbp->path1, _("link"));
@@ -2419,7 +2548,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		link_in(dsth);
 	}
 
-	/* finally, pass through remaining src list, unlinking/disowning.
+	/*
+	 * finally, pass through remaining src list, unlinking/disowning.
 	 * tes@sgi.com: don't believe this will happen as this step
 	 * should now be done in noref_elim_recurse().
 	 */
@@ -2467,7 +2597,8 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 	return BOOL_TRUE;
 }
 
-/* traverse tree depth-wise bottom-up for dirs no longer referenced.
+/*
+ * traverse tree depth-wise bottom-up for dirs no longer referenced.
  * if non-empty, move children to orphanage
  */
 bool_t
@@ -2497,7 +2628,8 @@ tree_setattr_recurse(nh_t parh, char *path)
 	while (cldh != NH_NULL) {
 		nh_t nextcldh;
 
-		/* get the node attributes
+		/*
+		 * get the node attributes
 		 */
 		node_t *cldp = Node_map(cldh);
 		bool_t isdirpr = (cldp->n_flags & NF_ISDIR);
@@ -2505,12 +2637,14 @@ tree_setattr_recurse(nh_t parh, char *path)
 		bool_t isrealpr = (cldp->n_flags & NF_REAL);
 		dah_t dah = cldp->n_dah;
 
-		/* get next cld
+		/*
+		 * get next cld
 		 */
 		nextcldh = cldp->n_sibh;
 		Node_unmap(cldh, &cldp);
 
-		/* if is a real selected dir, go ahead.
+		/*
+		 * if is a real selected dir, go ahead.
 		 */
 		if (isdirpr && isselpr && isrealpr) {
 			bool_t ok;
@@ -2571,7 +2705,8 @@ setdirattr(dah_t dah, char *path)
 		fssetdm.fsd_padding = 0;	/* not used */
 		fssetdm.fsd_dmstate = (uint16_t)dirattr_get_dmstate(dah);
 
-		/* restore DMAPI event settings etc.
+		/*
+		 * restore DMAPI event settings etc.
 		 */
 		rval = ioctl(fd,
 			      XFS_IOC_FSSETDM,
@@ -2621,7 +2756,8 @@ setdirattr(dah_t dah, char *path)
 		      strerror(errno));
 	}
 
-	/* set the extended inode flags
+	/*
+	 * set the extended inode flags
 	 */
 	if (!tranp->t_dstdirisxfspr)
 		return;
@@ -2652,7 +2788,8 @@ setdirattr(dah_t dah, char *path)
 	(void)close(fd);
 }
 
-/* deletes orphanage if empty, else warns
+/*
+ * deletes orphanage if empty, else warns
  */
 bool_t
 tree_delorph(void)
@@ -2712,11 +2849,13 @@ tree_subtree_inter(void)
 	dlog_ucbp_t cmdp;
 
 restart:
-	/* make the current working directory the root of the fs
+	/*
+	 * make the current working directory the root of the fs
 	 */
 	tranp->t_inter.i_cwdh = persp->p_rooth;
 
-	/* begin the dialog
+	/*
+	 * begin the dialog
 	 */
 	preamblecnt = 0;
 	fold_init(fold, _("subtree selection dialog"), '=');
@@ -2726,7 +2865,8 @@ restart:
 	assert(preamblecnt <= PREAMBLEMAX);
 	dlog_begin(preamblestr, preamblecnt);
 
-	/* execute commands until time to extract or quit. always begin with
+	/*
+	 * execute commands until time to extract or quit. always begin with
 	 * an implicit instructions command. if see SIGINT, give main thread
 	 * dialog a chance to decide if a session interrupt is wanted.
 	 */
@@ -2738,7 +2878,8 @@ restart:
 		const ix_t okix = 3;
 		ix_t responseix;
 
-		/* execute command and get response
+		/*
+		 * execute command and get response
 		 */
 		responseix = dlog_string_query(cmdp,
 					        0,
@@ -2751,7 +2892,8 @@ restart:
 						abortix,  /* sigquit ix */
 						okix);   /* ok ix */
 
-		/* ack the response
+		/*
+		 * ack the response
 		 */
 		ackcnt = 0;
 		if (responseix == sigintix) {
@@ -2765,10 +2907,12 @@ restart:
 		dlog_string_ack(ackstr,
 				 ackcnt);
 
-		/* exception handling
+		/*
+		 * exception handling
 		 */
 		if (responseix != okix) {
-			/* if exception, end the dialog. may restart
+			/*
+			 * if exception, end the dialog. may restart
 			 * if operator decidesd not to intr.
 			 */
 			postamblecnt = 0;
@@ -2779,13 +2923,15 @@ restart:
 			assert(postamblecnt <= POSTAMBLEMAX);
 			dlog_end(postamblestr, postamblecnt);
 
-			/* if sighup or sigquit, immediately quit
+			/*
+			 * if sighup or sigquit, immediately quit
 			 */
 			if (responseix == abortix) {
 				return BOOL_FALSE;
 			}
 
-			/* if sigint, allow main thread to decide if
+			/*
+			 * if sigint, allow main thread to decide if
 			 * operator really wants to quit
 			 */
 			assert(responseix == sigintix);
@@ -2820,7 +2966,8 @@ restart:
 	assert(postamblecnt <= POSTAMBLEMAX);
 	dlog_end(postamblestr, postamblecnt);
 
-	/* pv 773569 - quit is not a reason to consider session
+	/*
+	 * pv 773569 - quit is not a reason to consider session
          * to be interrupted (we haven't started yet) so just unmark
          * any selected directories and return */
 	if (cmdp == tsi_cmd_quit) {
@@ -2844,14 +2991,16 @@ tsi_cmd_pwd(void *ctxp,
 	     dlog_pcbp_t pcb,
 	     void *pctxp)
 {
-	/* special case root
+	/*
+	 * special case root
 	 */
 	if (tranp->t_inter.i_cwdh == persp->p_rooth) {
 		(*pcb)(pctxp, "cwd is fs root\n");
 		return;
 	}
 
-	/* ascend tree recursively, print path on way back
+	/*
+	 * ascend tree recursively, print path on way back
 	 */
 	tsi_cmd_pwd_recurse(ctxp, pcb, pctxp, tranp->t_inter.i_cwdh);
 	(*pcb)(pctxp, "\n");
@@ -2905,7 +3054,8 @@ tsi_cmd_ls(void *ctxp,
 	bool_t isdirpr;
 	bool_t isselpr;
 
-	/* walk the tree according to the path argument, to get
+	/*
+	 * walk the tree according to the path argument, to get
 	 * the named node.
 	 */
 	ok = tsi_walkpath(arg,
@@ -2923,7 +3073,8 @@ tsi_cmd_ls(void *ctxp,
 		return;
 	}
 
-	/* if named is not a dir, just display named
+	/*
+	 * if named is not a dir, just display named
 	 */
 	if (! isdirpr) {
 		(*pcb)(pctxp,
@@ -2936,7 +3087,8 @@ tsi_cmd_ls(void *ctxp,
 		return;
 	}
 
-	/* iterate through the directory, printing all matching entries.
+	/*
+	 * iterate through the directory, printing all matching entries.
 	 * hide the orphanage.
 	 */
 	while (cldh != NH_NULL) {
@@ -2985,7 +3137,8 @@ tsi_cmd_cd(void *ctxp,
 	bool_t isselpr;
 	bool_t ok;
 
-	/* walk the tree according to the path argument, to get
+	/*
+	 * walk the tree according to the path argument, to get
 	 * the named node.
 	 */
 	ok = tsi_walkpath(arg,
@@ -3003,7 +3156,8 @@ tsi_cmd_cd(void *ctxp,
 		return;
 	}
 
-	/* if named is not a dir, complain
+	/*
+	 * if named is not a dir, complain
 	 */
 	if (! isdirpr) {
 		assert(arg);
@@ -3014,7 +3168,8 @@ tsi_cmd_cd(void *ctxp,
 		return;
 	}
 
-	/* change the current working directory
+	/*
+	 * change the current working directory
 	 */
 	tranp->t_inter.i_cwdh = namedh;
 }
@@ -3036,7 +3191,8 @@ tsi_cmd_add(void *ctxp,
 	bool_t isselpr;
 	bool_t ok;
 
-	/* walk the tree according to the path argument, to get
+	/*
+	 * walk the tree according to the path argument, to get
 	 * the named node.
 	 */
 	ok = tsi_walkpath(arg,
@@ -3074,7 +3230,8 @@ tsi_cmd_delete(void *ctxp,
 	bool_t isselpr;
 	bool_t ok;
 
-	/* walk the tree according to the path argument, to get
+	/*
+	 * walk the tree according to the path argument, to get
 	 * the named node.
 	 */
 	ok = tsi_walkpath(arg,
@@ -3209,7 +3366,8 @@ tsi_cmd_help(void *ctxp,
 	}
 }
 
-/* walks the tree following the given path.
+/*
+ * walks the tree following the given path.
  * returns FALSE if syntax error encountered.
  * returns by reference handles to the named node, its parent,
  * the first child in its cld list, its ino, if it is a directory,
@@ -3233,17 +3391,20 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 	bool_t isselpr;
 
 
-	/* correct arg if ends with slash (if arg is "/", ok)
+	/*
+	 * correct arg if ends with slash (if arg is "/", ok)
 	 */
 	if (arg && strlen(arg) > 1 && arg[strlen(arg) - 1] == '/') {
 		arg[strlen(arg) - 1] = 0;
 	}
 
-	/* use path to walk down the path argument
+	/*
+	 * use path to walk down the path argument
 	 */
 	path = arg;
 
-	/* walk the tree beginning either at the root node
+	/*
+	 * walk the tree beginning either at the root node
 	 * or at the current working directory
 	 */
 	if (path && *path == '/') {
@@ -3255,7 +3416,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 		namedh = cwdh;
 	}
 
-	/* get the parent of the starting point, and its cld list
+	/*
+	 * get the parent of the starting point, and its cld list
 	 */
 	namedp = Node_map(namedh);
 	parh = namedp->n_parh;
@@ -3266,7 +3428,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 	Node_unmap(namedh, &namedp);
 	isdirpr = BOOL_TRUE;
 
-	/* walk the tree from the starting point following the path arg.
+	/*
+	 * walk the tree from the starting point following the path arg.
 	 * on leaving this loop, the following will be valid:
 	 *	namedh  - the handle of the node named by path arg;
 	 *	parh - the parent of the named node;
@@ -3278,26 +3441,30 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 		char *strpatchp;
 		nh_t sibh;
 
-		/* if no path arg, break
+		/*
+		 * if no path arg, break
 		 */
 		if (! path) {
 			break;
 		}
 
-		/* clean out leading slashes. these can occur if the
+		/*
+		 * clean out leading slashes. these can occur if the
 		 * path arg is ".../////..." or "////..."
 		 */
 		while (*path == '/') {
 			path++;
 		}
 
-		/* if empty path arg, break
+		/*
+		 * if empty path arg, break
 		 */
 		if (! strlen(path)) {
 			break;
 		}
 
-		/* copy the first name from the path, and advance
+		/*
+		 * copy the first name from the path, and advance
 		 * the path pointer.
 		 */
 		namelen = strcspn(path, "/");
@@ -3314,7 +3481,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			strpatchp = 0;
 		}
 
-		/* be sure the named node is a dir
+		/*
+		 * be sure the named node is a dir
 		 */
 		if (! isdirpr) {
 			if (pcb) {
@@ -3325,7 +3493,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			return BOOL_FALSE;
 		}
 
-		/* special case "."
+		/*
+		 * special case "."
 		 */
 		if (! strcmp(nbuf, ".")) {
 			if (strpatchp) {
@@ -3334,7 +3503,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			continue;
 		}
 
-		/* special case ".."
+		/*
+		 * special case ".."
 		 */
 		if (! strcmp(nbuf, "..")) {
 			if (parh == NH_NULL) {
@@ -3358,7 +3528,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			continue;
 		}
 
-		/* look for child with right name
+		/*
+		 * look for child with right name
 		 */
 		sibh = cldh;
 		while (sibh != NH_NULL) {
@@ -3389,7 +3560,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			sibh = nextsibh;
 		}
 
-		/* if no match, complain
+		/*
+		 * if no match, complain
 		 */
 		if (sibh == NH_NULL) {
 			if (pcb) {
@@ -3400,7 +3572,8 @@ tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			return BOOL_FALSE;
 		}
 
-		/* continue search. cldh, ino and isdirpr
+		/*
+		 * continue search. cldh, ino and isdirpr
 		 * set in inner loop above
 		 */
 		parh = namedh;
@@ -3493,7 +3666,8 @@ Node_unmap(nh_t nh, node_t **npp)
 	node_unmap(nh, (void **)npp);
 }
 
-/* builds a pathname for the specified node, relative to root
+/*
+ * builds a pathname for the specified node, relative to root
  * returns FALSE if pathname too long
  */
 static bool_t
@@ -3520,7 +3694,8 @@ Node2path(nh_t nh, char *path, char *errmsg)
 	}
 }
 
-/* returns how much of the buffer remains, assuming the buffer size is
+/*
+ * returns how much of the buffer remains, assuming the buffer size is
  * MAXPATHLEN. always null-terminates, but null char not counted in return.
  * works because the buffer size is secretly 2 * MAXPATHLEN.
  */
@@ -3537,13 +3712,15 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 	int oldbufsz;
 	int namelen;
 
-	/* recursion termination
+	/*
+	 * recursion termination
 	 */
 	if (nh == persp->p_rooth) {
 		return bufsz;
 	}
 
-	/* if we have a cache hit, no need to recurse any further
+	/*
+	 * if we have a cache hit, no need to recurse any further
 	 */
 	if (nh == cache.nh) {
 		assert(bufsz > cache.len);
@@ -3551,7 +3728,8 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 		return bufsz - cache.len;
 	}
 
-	/* extract useful node members
+	/*
+	 * extract useful node members
 	 */
 	np = Node_map(nh);
 	parh = np->n_parh;
@@ -3560,7 +3738,8 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 	nrh = np->n_nrh;
 	Node_unmap(nh, &np);
 
-	/* build path to parent
+	/*
+	 * build path to parent
 	 */
 	oldbuf = buf;
 	oldbufsz = bufsz;
@@ -3570,7 +3749,8 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 	}
 	buf += oldbufsz - bufsz;
 
-	/* insert slash if parent not root
+	/*
+	 * insert slash if parent not root
 	 */
 	if (parh != persp->p_rooth) {
 		assert(bufsz + MAXPATHLEN >= 2);
@@ -3582,7 +3762,8 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 		}
 	}
 
-	/* append entry name: special case if in orphanage
+	/*
+	 * append entry name: special case if in orphanage
 	 */
 	if (parh == persp->p_orphh) {
 		namelen = sprintf(buf, "%llu.%u", (unsigned long long)ino, gen);
@@ -3594,12 +3775,14 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 		assert(namelen > 0);
 	}
 
-	/* update remaining buffer size
+	/*
+	 * update remaining buffer size
 	 */
 	bufsz -= namelen;
 	assert(bufsz + MAXPATHLEN > 0);
 
-	/* update the cache if we're the target's parent
+	/*
+	 * update the cache if we're the target's parent
 	 * (and the pathname is not too long)
 	 */
 	if (level == 1 && bufsz > 0) {
@@ -3608,7 +3791,8 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 		cache.len = oldbufsz - bufsz;
 	}
 
-	/* return remaining buffer size
+	/*
+	 * return remaining buffer size
 	 */
 	return bufsz;
 }
@@ -3714,7 +3898,8 @@ disown(nh_t cldh)
 	return nrh;
 }
 
-/* recursively marks all nodes in subtree as selected or not selected
+/*
+ * recursively marks all nodes in subtree as selected or not selected
  * for subtree restoral. adjusts ancestors flags accordingly. also adjusts
  * inomap, which will be used by content.c to see if a media file contains
  * any nondirs which might need to be restored.
@@ -3725,17 +3910,20 @@ selsubtree(nh_t nh, bool_t sensepr)
 	node_t *np;
 	nh_t parh;
 
-	/* first mark the subtree
+	/*
+	 * first mark the subtree
 	 */
 	selsubtree_recurse_down(nh, sensepr);
 
-	/* get parent
+	/*
+	 * get parent
 	 */
 	np = Node_map(nh);
 	parh = np->n_parh;
 	Node_unmap(nh, &np);
 
-	/* next adjust ancestory
+	/*
+	 * next adjust ancestory
 	 */
 	while (parh != NH_NULL) {
 		node_t *parp;
@@ -3767,7 +3955,8 @@ selsubtree(nh_t nh, bool_t sensepr)
 			}
 			if (! atleastonechildselpr) {
 				parp->n_flags &= ~NF_SUBTREE;
-				/* DBG could break out here (remember to unmap!)
+				/*
+				 * DBG could break out here (remember to unmap!)
 				 */
 			}
 		}
@@ -3782,7 +3971,8 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
 {
 	nh_t cldh;
 
-	/* first mark the node indicated, and get head of cld list
+	/*
+	 * first mark the node indicated, and get head of cld list
 	 */
 	{
 		node_t *np;
@@ -3805,7 +3995,8 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
 			if (sensepr) {
 				inomap_rst_add(ino);
 			} else {
-				/* check hardlist: don't del unless none needed
+				/*
+				 * check hardlist: don't del unless none needed
 				 */
 				nh_t nh;
 				bool_t neededpr = BOOL_FALSE;
@@ -3831,7 +4022,8 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
 		}
 	}
 
-	/* then mark all of its children. be sure to skip the orphanage!!!
+	/*
+	 * then mark all of its children. be sure to skip the orphanage!!!
 	 */
 	while (cldh != NH_NULL) {
 		node_t *cldp;
@@ -3850,7 +4042,8 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
 
 /* link abstraction *********************************************************/
 
-/* returns handle to head of hard link list
+/*
+ * returns handle to head of hard link list
  */
 static nh_t
 link_hardh(xfs_ino_t ino, gen_t gen)
@@ -3858,7 +4051,8 @@ link_hardh(xfs_ino_t ino, gen_t gen)
 	return hash_find(ino, gen);
 }
 
-/* returns following node in hard link list
+/*
+ * returns following node in hard link list
  */
 static nh_t
 link_nexth(nh_t nh)
@@ -3872,7 +4066,8 @@ link_nexth(nh_t nh)
 	return nexth;
 }
 
-/* searches hard link list for exact match.
+/*
+ * searches hard link list for exact match.
  * returns hard link list head
  */
 static nh_t
@@ -3914,17 +4109,20 @@ link_in(nh_t nh)
 	    "link_in(%llu): map in node\n", nh);
 #endif
 
-	/* map in the node to read ino and gen
+	/*
+	 * map in the node to read ino and gen
 	 */
 	np = Node_map(nh);
 	ino = np->n_ino;
 	gen = np->n_gen;
 
-	/* see if one or more links already hashed.
+	/*
+	 * see if one or more links already hashed.
 	 */
 	hardh = hash_find(ino, gen);
 
-	/* if not hashed, just hash it. otherwise put at end
+	/*
+	 * if not hashed, just hash it. otherwise put at end
 	 * of hard link (lnk) list.
 	 */
 	if (hardh == NH_NULL) {
@@ -3950,7 +4148,8 @@ link_in(nh_t nh)
 		Node_unmap(prevh, &prevp);
 	}
 
-	/* since always put at end of hard link list, make node's
+	/*
+	 * since always put at end of hard link list, make node's
 	 * lnk member terminate list.
 	 */
 	np->n_lnkh = NH_NULL;
@@ -3969,18 +4168,21 @@ link_out(nh_t nh)
 	gen_t gen;
 	nh_t hardh;
 
-	/* map in the node to read ino and gen
+	/*
+	 * map in the node to read ino and gen
 	 */
 	np = Node_map(nh);
 	ino = np->n_ino;
 	gen = np->n_gen;
 
-	/* get head of hard link list
+	/*
+	 * get head of hard link list
 	 */
 	hardh = hash_find(ino, gen);
 	assert(hardh != NH_NULL);
 
-	/* if node is at head of hard link list, hash it out and
+	/*
+	 * if node is at head of hard link list, hash it out and
 	 * hash in the following node in link list, if there is one.
 	 * otherwise, unlink from hardlink list.
 	 */
@@ -4004,12 +4206,14 @@ link_out(nh_t nh)
 	}
 	np->n_lnkh = NH_NULL;
 
-	/* release the mapping
+	/*
+	 * release the mapping
 	 */
 	Node_unmap(nh, &np);
 }
 
-/* invokes callback for all hardheads
+/*
+ * invokes callback for all hardheads
  * iteration aborted if callback returns FALSE
  */
 static void
@@ -4018,7 +4222,8 @@ link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh), void *contextp)
 	hash_iter(cbfp, contextp);
 }
 
-/* iterator for a hard link list. allows deletion of the last node
+/*
+ * iterator for a hard link list. allows deletion of the last node
  * returned.
  */
 static void
@@ -4036,24 +4241,28 @@ link_iter_next(link_iter_context_t *link_iter_contextp)
 	node_t *lastp;
 	nh_t tmplasth;
 
-	/* if already done, return
+	/*
+	 * if already done, return
 	 */
 	if (link_iter_contextp->li_donepr == BOOL_TRUE) {
 		return NH_NULL;
 	}
 
-	/* if no hardhead, done
+	/*
+	 * if no hardhead, done
 	 */
 	if (link_iter_contextp->li_headh == NH_NULL) {
 		link_iter_contextp->li_donepr = BOOL_TRUE;
 		return NH_NULL;
 	}
 
-	/* make tmp copy of last
+	/*
+	 * make tmp copy of last
 	 */
 	tmplasth = link_iter_contextp->li_lasth;
 
-	/* if no last, must be first call
+	/*
+	 * if no last, must be first call
 	 */
 	if (tmplasth == NH_NULL) {
 		assert(link_iter_contextp->li_prevh == NH_NULL);
@@ -4061,20 +4270,23 @@ link_iter_next(link_iter_context_t *link_iter_contextp)
 		return link_iter_contextp->li_lasth;
 	}
 
-	/* slide last into prev
+	/*
+	 * slide last into prev
 	 */
 	link_iter_contextp->li_prevh = tmplasth;
 	lastp = Node_map(tmplasth);
 	link_iter_contextp->li_lasth = lastp->n_lnkh;
 	Node_unmap(tmplasth, &lastp);
 
-	/* if NULL, flag done
+	/*
+	 * if NULL, flag done
 	 */
 	if (link_iter_contextp->li_lasth == NH_NULL) {
 		link_iter_contextp->li_donepr = BOOL_TRUE;
 	}
 
-	/* return the last handle
+	/*
+	 * return the last handle
 	 */
 	return link_iter_contextp->li_lasth;
 }
@@ -4086,12 +4298,14 @@ link_iter_unlink(link_iter_context_t *link_iter_contextp, nh_t nh)
 	node_t *lastp;
 	nh_t nexth;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(link_iter_contextp->li_lasth != NH_NULL);
 	assert(nh == link_iter_contextp->li_lasth);
 
-	/* get the next node in list
+	/*
+	 * get the next node in list
 	 */
 	lastp = Node_map(link_iter_contextp->li_lasth);
 	nexth = lastp->n_lnkh;
@@ -4133,11 +4347,13 @@ hash_init(size64_t vmsz,
 	size64_t hashlenmax;
 	ix_t hix;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(pgsz % sizeof(nh_t) == 0);
 
-	/* calculate the size of the hash array. must be a power of two,
+	/*
+	 * calculate the size of the hash array. must be a power of two,
 	 * and a multiple of the page size. don't use more than the available
 	 * vm. but enforce a minimum.
 	 */
@@ -4159,11 +4375,13 @@ hash_init(size64_t vmsz,
 		hashlen >>= 1;
 	assert(hashlen <= hashlenmax);
 
-	/* record hash size in persistent state
+	/*
+	 * record hash size in persistent state
 	 */
 	persp->p_hashsz = hashlen * sizeof(nh_t);
 
-	/* map the hash array just after the persistent state header
+	/*
+	 * map the hash array just after the persistent state header
 	 */
 	assert(persp->p_hashsz <= SIZEMAX);
 	assert(! (persp->p_hashsz % (size64_t)pgsz));
@@ -4180,13 +4398,15 @@ hash_init(size64_t vmsz,
 		return BOOL_FALSE;
 	}
 
-	/* initialize the hash array to all NULL node handles
+	/*
+	 * initialize the hash array to all NULL node handles
 	 */
 	for (hix = 0; hix < (ix_t)hashlen; hix++) {
 		tranp->t_hashp[hix] = NH_NULL;
 	}
 
-	/* build a hash mask. this works because hashlen is a power of two.
+	/*
+	 * build a hash mask. this works because hashlen is a power of two.
 	 * record in persistent state.
 	 */
 	assert(hashlen - 1 <= SIZEMAX);
@@ -4200,16 +4420,19 @@ hash_sync(char *perspath)
 {
 	size64_t hashsz;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(pgsz % sizeof(nh_t) == 0);
 
-	/* retrieve the hash size from the persistent state
+	/*
+	 * retrieve the hash size from the persistent state
 	 */
 	hashsz = persp->p_hashsz;
 	assert(! (hashsz % sizeof(nh_t)));
 
-	/* map the hash array just after the persistent state header
+	/*
+	 * map the hash array just after the persistent state header
 	 */
 	assert(hashsz <= SIZEMAX);
 	assert(! (hashsz % (size64_t)pgsz));
@@ -4249,33 +4472,40 @@ hash_in(nh_t nh)
 	size_t hix;
 	nh_t *entryp;
 
-	/* get a mapping to the node
+	/*
+	 * get a mapping to the node
 	 */
 	np = Node_map(nh);
 
-	/* get ino from node
+	/*
+	 * get ino from node
 	 */
 	ino = np->n_ino;
 
-	/* assert not already in
+	/*
+	 * assert not already in
 	 */
 	assert(hash_find(np->n_ino, np->n_gen) == NH_NULL);
 
-	/* calculate the hash index
+	/*
+	 * calculate the hash index
 	 */
 	hix = hash_val(ino, persp->p_hashmask);
 
-	/* get a pointer to the indexed hash array entry
+	/*
+	 * get a pointer to the indexed hash array entry
 	 */
 	entryp = &tranp->t_hashp[hix];
 
-	/* insert into the list, at the head
+	/*
+	 * insert into the list, at the head
 	 */
 	assert(np->n_hashh == NH_NULL);
 	np->n_hashh = *entryp;
 	*entryp = nh;
 
-	/* release the mapping
+	/*
+	 * release the mapping
 	 */
 	Node_unmap(nh, &np);
 }
@@ -4289,25 +4519,30 @@ hash_out(nh_t nh)
 	size_t hix;
 	nh_t *entryp;
 
-	/* get a mapping to the node
+	/*
+	 * get a mapping to the node
 	 */
 	np = Node_map(nh);
 
-	/* get the ino
+	/*
+	 * get the ino
 	 */
 	ino = np->n_ino;
 
-	/* get a pointer to the hash array entry
+	/*
+	 * get a pointer to the hash array entry
 	 */
 	hix = hash_val(ino, persp->p_hashmask);
 	entryp = &tranp->t_hashp[hix];
 
-	/* get the handle of the first node in the appropriate hash array
+	/*
+	 * get the handle of the first node in the appropriate hash array
 	 */
 	hashheadh = *entryp;
 	assert(hashheadh != NH_NULL);
 
-	/* if node is first in list, replace entry with following node.
+	/*
+	 * if node is first in list, replace entry with following node.
 	 * otherwise, walk the list until found.
 	 */
 	if (hashheadh == nh) {
@@ -4327,7 +4562,8 @@ hash_out(nh_t nh)
 	}
 	np->n_hashh = NH_NULL;
 
-	/* release the mapping
+	/*
+	 * release the mapping
 	 */
 	Node_unmap(nh, &np);
 }
@@ -4339,12 +4575,14 @@ hash_find(xfs_ino_t ino, gen_t gen)
 	node_t *np;
 	size_t hix;
 
-	/* get handle to first node in appropriate hash array
+	/*
+	 * get handle to first node in appropriate hash array
 	 */
 	hix = hash_val(ino, persp->p_hashmask);
 	nh = tranp->t_hashp[hix];
 
-	/* if list empty, return null handle
+	/*
+	 * if list empty, return null handle
 	 */
 	if (nh == NH_NULL) {
 		return NH_NULL;
@@ -4356,7 +4594,8 @@ hash_find(xfs_ino_t ino, gen_t gen)
 		ino, gen);
 #endif
 
-	/* walk the list until found.
+	/*
+	 * walk the list until found.
 	 */
 	np = Node_map(nh);
 	while (np->n_ino != ino || np->n_gen != gen) {
@@ -4377,7 +4616,8 @@ hash_find(xfs_ino_t ino, gen_t gen)
 	return nh;
 }
 
-/* invokes callback for all hashed nodes
+/*
+ * invokes callback for all hashed nodes
  * iteration aborted if callback returns FALSE
  * call back may hash out and free the node, so
  * must figure next node prior to calling callback.
@@ -4413,7 +4653,8 @@ hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh), void *contextp)
 /* misc static functions *****************************************************/
 
 #ifdef TREE_CHK
-/* use hash array to iterate through all nodes. check
+/*
+ * use hash array to iterate through all nodes. check
  * each node's hash, hardlink, namreg, dirattr, parent,
  * and sibling handles.
  */
@@ -4652,11 +4893,13 @@ parse(int slotcnt, char **slotbuf, char *string)
 	char *l;
 	size_t wordcnt;
 
-	/* sanity checkcs
+	/*
+	 * sanity checkcs
 	 */
 	assert(slotcnt >= 0);
 
-	/* allocate a companion to the input string for identifying
+	/*
+	 * allocate a companion to the input string for identifying
 	 * characters which are to be interpreted literally.
 	 */
 	liter = (char *)calloc(1, strlen(string) + 1);
@@ -4664,7 +4907,8 @@ parse(int slotcnt, char **slotbuf, char *string)
 		return -1;
 	}
 
-	/* pass 1: collapse escape sequences, identifying characters which
+	/*
+	 * pass 1: collapse escape sequences, identifying characters which
 	 * are to be interpreted literally
 	 */
 	for (s = string, l = liter; *s; s++, l++) {
@@ -4673,7 +4917,8 @@ parse(int slotcnt, char **slotbuf, char *string)
 		}
 	}
 
-	/* pass 2: collapse quoted spans, identifying characters which
+	/*
+	 * pass 2: collapse quoted spans, identifying characters which
 	 * are to be interpreted literally
 	 */
 	for (s = string, l = liter; *s; s++, l++) {
@@ -4682,7 +4927,8 @@ parse(int slotcnt, char **slotbuf, char *string)
 		}
 	}
 
-	/* pass 3: collapse white space spans into a single space
+	/*
+	 * pass 3: collapse white space spans into a single space
 	 */
 	for (s = string, l = liter; *s; s++, l++) {
 		if (is_white(*s) && ! *l) {
@@ -4690,7 +4936,8 @@ parse(int slotcnt, char **slotbuf, char *string)
 		}
 	}
 
-	/* pass 4: identify and null-terminate words
+	/*
+	 * pass 4: identify and null-terminate words
 	 */
 	wordcnt = 0;
 	s = string;
@@ -4745,7 +4992,8 @@ fix_escape(char *string, char *liter)
 	escape_table_t *ep;
 	escape_table_t *endep;
 
-	/* first look for special escapes described in table
+	/*
+	 * first look for special escapes described in table
 	 */
 	ep = escape_table;
 	endep = escape_table + (sizeof(escape_table)
@@ -4761,7 +5009,8 @@ fix_escape(char *string, char *liter)
 		}
 	}
 
-	/* detect white space escapes
+	/*
+	 * detect white space escapes
 	 */
 	if (is_white(string[1])) {
 		liter[0] = (char)1;
@@ -4770,7 +5019,8 @@ fix_escape(char *string, char *liter)
 		return;
 	}
 
-	/* detect hex escapes (don't allow null)
+	/*
+	 * detect hex escapes (don't allow null)
 	 */
 	if (string[1] == 'x') {
 		size_t hexlen;
@@ -4793,7 +5043,8 @@ fix_escape(char *string, char *liter)
 		}
 	}
 
-	/* detect octal escapes (don't allow null)
+	/*
+	 * detect octal escapes (don't allow null)
 	 */
 	if (is_octal(string[1])) {
 		size_t octallen;
@@ -4816,7 +5067,8 @@ fix_escape(char *string, char *liter)
 		}
 	}
 
-	/* didn't match any escape sequences, so assume literal
+	/*
+	 * didn't match any escape sequences, so assume literal
 	 */
 	liter[0] = (char)1;
 }
@@ -4827,12 +5079,14 @@ fix_quoted_span(char *string, char *liter)
 	char *s;
 	char *l;
 
-	/* first cover the leading quote
+	/*
+	 * first cover the leading quote
 	 */
 	shrink(string, 1);
 	shrink(liter, 1);
 
-	/* scan for the next non-literal quote, marking all
+	/*
+	 * scan for the next non-literal quote, marking all
 	 * characters in between as literal
 	 */
 	for (s = string, l = liter; *s && (*s != '\"' || *l); s++, l++) {
diff --git a/restore/tree.h b/restore/tree.h
index 4f9ffe8..69086bf 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -18,7 +18,8 @@
 #ifndef TREE_H
 #define TREE_H
 
-/* tree_init - creates a new tree abstraction.
+/*
+ * tree_init - creates a new tree abstraction.
  */
 extern bool_t tree_init(char *hkdir,
 			 char *dstdir,
@@ -36,7 +37,8 @@ extern bool_t tree_init(char *hkdir,
 			 uint32_t dumpformat,
 			 bool_t truncategenpr);
 
-/* tree_sync - synchronizes with an existing tree abstraction
+/*
+ * tree_sync - synchronizes with an existing tree abstraction
  */
 extern bool_t tree_sync(char *hkdir,
 			 char *dstdir,
@@ -44,7 +46,8 @@ extern bool_t tree_sync(char *hkdir,
 			 bool_t fullpr,
 			 bool_t dstdirisxfspr);
 
-/* tree_check_dump_format - detect the rare case where a
+/*
+ * tree_check_dump_format - detect the rare case where a
  * cumulative restore begins with a format 3 (or newer)
  * dump, and a later restore in the series encounters
  * a format 2 dump. the restore will fail unless the
@@ -53,13 +56,15 @@ extern bool_t tree_sync(char *hkdir,
 extern bool_t tree_check_dump_format(uint32_t dumpformat);
 
 
-/* tree_begindir - begins application of dumped directory to tree.
+/*
+ * tree_begindir - begins application of dumped directory to tree.
  * returns handle to dir node. returns by reference the dirattr
  * handle if new. caller must pre-zero (DAH_NULL).
  */
 extern nh_t tree_begindir(filehdr_t *fhdrp, dah_t *dahp);
 
-/* tree_addent - adds a directory entry; takes dirh from above call
+/*
+ * tree_addent - adds a directory entry; takes dirh from above call
  */
 extern rv_t tree_addent(nh_t dirh,
 			 xfs_ino_t ino,
@@ -67,25 +72,29 @@ extern rv_t tree_addent(nh_t dirh,
 			 char *name,
 			 size_t namelen);
 
-/* ends application of dir
+/*
+ * ends application of dir
  */
 extern void tree_enddir(nh_t dirh);
 
 #ifdef TREE_CHK
-/* tree_chk - do a sanity check of the tree prior to post-processing and
+/*
+ * tree_chk - do a sanity check of the tree prior to post-processing and
  * non-dir restoral. returns FALSE if corruption detected.
  */
 extern bool_t tree_chk(void);
 #endif /* TREE_CHK */
 
-/* tree_marknoref - mark all nodes as no reference, not dumped dirs, and
+/*
+ * tree_marknoref - mark all nodes as no reference, not dumped dirs, and
  * clear all directory attribute handles. done at the beginning
  * of the restoral of a dump session, in order to detect directory entries
  * no longer needed.
  */
 extern void tree_marknoref(void);
 
-/* mark all nodes in tree as either selected or unselected, depending on sense
+/*
+ * mark all nodes in tree as either selected or unselected, depending on sense
  */
 extern void tree_markallsubtree(bool_t sensepr);
 
@@ -105,7 +114,8 @@ extern rv_t tree_cb_links(xfs_ino_t ino,
 			   char *path1,
 			   char *path2);
 
-/* called after all dirs have been restored. adjusts the ref flags,
+/*
+ * called after all dirs have been restored. adjusts the ref flags,
  * by noting that dirents not refed because their parents were not dumped
  * are virtually reffed if their parents are refed.
  */
@@ -117,7 +127,8 @@ extern bool_t tree_subtree_inter(void);
 
 extern bool_t tree_extattr(bool_t (*cbfunc)(char *path, dah_t dah),
 			    char *path);
-	/* does a depthwise bottom-up traversal of the tree, calling
+	/*
+	 * does a depthwise bottom-up traversal of the tree, calling
 	 * the supplied callback for all directories with a non-NULL dirattr
 	 * handle. The callback will get called with the directory's pathname
 	 * and it dirattr handle. the traversal will be aborted if the
diff --git a/restore/win.c b/restore/win.c
index d3fe4dc..27d0d4f 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -35,7 +35,8 @@
 extern size_t pgsz;
 extern size_t pgmask;
 
-/* number of entries to add to the segmap if
+/*
+ * number of entries to add to the segmap if
  * it needs to be resized
  */
 #define SEGMAP_INCR	16
@@ -46,70 +47,89 @@ extern size_t pgmask;
 #define CRITICAL_BEGIN()  if (!locksoffpr) qlock_lock(tranp->t_qlockh)
 #define CRITICAL_END()    if (!locksoffpr) qlock_unlock(tranp->t_qlockh)
 
-/* window descriptor
+/*
+ * window descriptor
  */
 struct win {
 	segix_t w_segix;
-		/* index of segment mapped by this window
+		/*
+		 * index of segment mapped by this window
 		 */
 	void *w_p;
-		/* window virtual address
+		/*
+		 * window virtual address
 		 */
 	size_t w_refcnt;
-		/* reference count
+		/*
+		 * reference count
 		 */
 	struct win *w_nextp;
-		/* LRU list forward linkage
+		/*
+		 * LRU list forward linkage
 		 */
 	struct win *w_prevp;
-		/* LRU list backward linkage
+		/*
+		 * LRU list backward linkage
 		 */
 };
 
 typedef struct win win_t;
 
-/* forward declarations
+/*
+ * forward declarations
  */
 static void win_segmap_resize(segix_t segix);
 
-/* transient state
+/*
+ * transient state
  */
 struct tran {
 	int t_fd;
-		/* file descriptor of backing store to be windowed
+		/*
+		 * file descriptor of backing store to be windowed
 		 */
 	off64_t t_firstoff;
-		/* offset of first seg within backing store (for mmap())
+		/*
+		 * offset of first seg within backing store (for mmap())
 		 */
 	size64_t t_segsz;
-		/* backing store segment / window size
+		/*
+		 * backing store segment / window size
 		 */
 	size_t t_winmax;
-		/* maximum number of windows to allocate
+		/*
+		 * maximum number of windows to allocate
 		 */
 	size_t t_wincnt;
-		/* number of windows allocated
+		/*
+		 * number of windows allocated
 		 */
 	size_t t_winmmaps;
-		/* number of window mmap calls made
+		/*
+		 * number of window mmap calls made
 		 */
 	win_t *t_lruheadp;
-		/* LRU head (re-use from this end)
+		/*
+		 * LRU head (re-use from this end)
 		 */
 	win_t *t_lrutailp;
-		/* LRU tail (put here when no refs)
+		/*
+		 * LRU tail (put here when no refs)
 		 */
 	win_t **t_segmap;
-		/* mapping from segment index to window. an entry
+		/*
+		 * mapping from segment index to window. an entry
 		 * points to a win_t struct if segment is currently
 		 * mapped, otherwise the entry is NULL.
 		 */
 	size_t	t_segmaplen;
-		/* number of segments currently represented in
+		/*
+		 * number of segments currently represented in
 		 * t_segmap array.
 		 */
 	qlockh_t t_qlockh;
-		/* for establishing critical regions
+		/*
+		 * for establishing critical regions
 		 */
 };
 
@@ -151,12 +171,14 @@ win_init(int fd,
 	  size64_t segsz,
 	  size_t winmax)
 {
-	/* validate parameters
+	/*
+	 * validate parameters
 	 */
 	assert((firstoff & (off64_t)pgmask) == 0);
 	assert((segsz & pgmask) == 0);
 
-	/* allocate and initialize transient state
+	/*
+	 * allocate and initialize transient state
 	 */
 	assert(tranp == 0);
 	tranp = (tran_t *)calloc(1, sizeof(tran_t));
@@ -172,7 +194,8 @@ win_init(int fd,
 	calloc(tranp->t_segmaplen, sizeof(win_t *));
 	assert(tranp->t_segmap);
 
-	/* initialize critical region enforcer
+	/*
+	 * initialize critical region enforcer
 	 */
 	tranp->t_qlockh = qlock_alloc(QLOCK_ORD_WIN);
 }
@@ -193,7 +216,8 @@ win_map(segix_t segix, void **pp)
 	if (segix >= tranp->t_segmaplen)
 		win_segmap_resize(segix);
 
-	/* see if segment already mapped. if ref cnt zero,
+	/*
+	 * see if segment already mapped. if ref cnt zero,
 	 * remove from LRU list.
 	 */
 	winp = tranp->t_segmap[segix];
@@ -234,7 +258,8 @@ win_map(segix_t segix, void **pp)
 		return;
 	}
 
-	/* Allocate a new descriptor if we haven't yet hit the maximum,
+	/*
+	 * Allocate a new descriptor if we haven't yet hit the maximum,
 	 * otherwise reuse any descriptor on the LRU list.
 	 */
 	if (tranp->t_wincnt < tranp->t_winmax) {
@@ -273,11 +298,13 @@ win_map(segix_t segix, void **pp)
 		return;
 	}
 
-	/* calculate offset of segment
+	/*
+	 * calculate offset of segment
 	 */
 	segoff = segix * (off64_t)tranp->t_segsz;
 
-	/* map the window
+	/*
+	 * map the window
 	 */
 	assert(tranp->t_segsz >= 1);
 	assert(tranp->t_firstoff
@@ -333,20 +360,23 @@ win_unmap(segix_t segix, void **pp)
 
 	CRITICAL_BEGIN();
 
-	/* verify window mapped
+	/*
+	 * verify window mapped
 	 */
 	assert(segix < tranp->t_segmaplen);
 	winp = tranp->t_segmap[segix];
 	assert(winp);
 
-	/* validate p
+	/*
+	 * validate p
 	 */
 	assert(pp);
 	assert(*pp);
 	assert(*pp >= winp->w_p);
 	assert(*pp < (void *)((char *)(winp->w_p) + tranp->t_segsz));
 
-	/* decrement the reference count. if zero, place at tail of LRU list.
+	/*
+	 * decrement the reference count. if zero, place at tail of LRU list.
 	 */
 	assert(winp->w_refcnt > 0);
 	winp->w_refcnt--;
@@ -367,7 +397,8 @@ win_unmap(segix_t segix, void **pp)
 		assert(! winp->w_nextp);
 	}
 
-	/* zero the caller's pointer
+	/*
+	 * zero the caller's pointer
 	 */
 	*pp = 0;
 
diff --git a/restore/win.h b/restore/win.h
index 2d52b56..5ade429 100644
--- a/restore/win.h
+++ b/restore/win.h
@@ -18,24 +18,28 @@
 #ifndef WIN_H
 #define WIN_H
 
-/* win.[ch] - windows into a very large file
+/*
+ * win.[ch] - windows into a very large file
  */
 
 typedef int segix_t;
 
-/* initialize the window abstraction
+/*
+ * initialize the window abstraction
  */
 void win_init(int fd,
 	       off64_t rngoff,		/* offset into file of windowing */
 	       size64_t winsz,		/* window size */
 	       size_t wincntmax);	/* max number of windows to manage */
 
-/* supply a pointer to the portion of the file identified by segix.
+/*
+ * supply a pointer to the portion of the file identified by segix.
  */
 void win_map(segix_t segix,		/* segment index to be mapped */
 	      void **pp);		/* returns pointer by reference */
 
-/* invalidate the pointer previously supplied. SIDE-EFFECT: zeros
+/*
+ * invalidate the pointer previously supplied. SIDE-EFFECT: zeros
  * by reference the caller's pointer.
  */
 void win_unmap(segix_t segix,		/* must match win_map param */
-- 
2.19.1
