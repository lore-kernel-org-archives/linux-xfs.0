Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4CFfK3O170755 for <xfs@oss.sgi.com>; Wed, 12 May 2010 10:41:20 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8253D13B80C7
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 08:43:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AkqyavvUu0H0cEpu for
	<xfs@oss.sgi.com>; Wed, 12 May 2010 08:43:33 -0700 (PDT)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4CFhWdf016085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 11:43:32 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o4CFhSbA031032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 11:43:31 -0400
Message-ID: <4BEACCA0.3070300@redhat.com>
Date: Wed, 12 May 2010 10:43:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsdocs: fix image scaling for pdf
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Apparently having: format="PNG" width="100%" scalefit="0"
in the image attributes is messing up scaling on the pdf
such that the images extend beyond the page.  (I inherited
all that from work our techpubs guy did).  On the advice
of another techpubs / publican expert, remove it - this 
seems to fix up the sizing on the pdf build.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/XFS_Filesystem_Structure/en-US/Allocation_Groups.xml b/XFS_Filesystem_Structure/en-US/Allocation_Groups.xml
index a745abe..2831721 100644
--- a/XFS_Filesystem_Structure/en-US/Allocation_Groups.xml
+++ b/XFS_Filesystem_Structure/en-US/Allocation_Groups.xml
@@ -32,7 +32,7 @@
 	</para>
 	<para>
 		<mediaobject>
-			<imageobject><imagedata fileref="images/6.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+			<imageobject><imagedata fileref="images/6.png"/></imageobject>
 			<textobject><phrase>6</phrase></textobject>
 		</mediaobject>
 		
@@ -681,7 +681,7 @@ typedef struct xfs_alloc_rec {
    <para>The following diagram shows a single level B+tree which consists of one leaf:</para>
 	<para>
 		<inlinemediaobject>
-			<imageobject><imagedata fileref="images/15a.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+			<imageobject><imagedata fileref="images/15a.png"/></imageobject>
 			<textobject><phrase>15a</phrase></textobject>
 		</inlinemediaobject>
 		
@@ -690,7 +690,7 @@ typedef struct xfs_alloc_rec {
    <para>With the intermediate nodes, the associated leaf pointers are stored in a separate array about two thirds into the block. The following diagram illustrates a 2-level B+tree for a free space B+tree:</para>
 	<para>
 		<mediaobject>
-			<imageobject><imagedata fileref="images/15b.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+			<imageobject><imagedata fileref="images/15b.png"/></imageobject>
 			<textobject><phrase>15b</phrase></textobject>
 		</mediaobject>
 		
@@ -709,7 +709,7 @@ typedef struct xfs_alloc_rec {
    <para>Active elements in the array are specified by the AGF's (<xref linkend="AG_Free_Space_Block"/>) <command>agf_flfirst</command>, <command>agf_fllast</command> and <command>agf_flcount</command> values. The array is managed as a circular list.</para>
 	<para>
 		<mediaobject>
-			<imageobject><imagedata fileref="images/16.png" format="PNG" /></imageobject>
+			<imageobject><imagedata fileref="images/16.png"/></imageobject>
 			<textobject><phrase>16</phrase></textobject>
 		</mediaobject>
 		
@@ -811,7 +811,7 @@ recs[1-344] = [startblock,blockcount]
 		<para>Absolute inode numbers include the AG number in the high bits, above the bits used for the AG relative inode number. Absolute inode numbers are found in directory (<xref linkend="Directories"/>) entries.</para>
    		<para>
  		      <mediaobject>
- 		      	<imageobject><imagedata fileref="images/18.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+ 		      	<imageobject><imagedata fileref="images/18.png"/></imageobject>
  		      	<textobject><phrase>18</phrase></textobject>
  		      </mediaobject>
  		      
@@ -913,7 +913,7 @@ typedef __be32 xfs_inobt_ptr_t;
    <para>The following diagram illustrates a single level inode B+tree:</para>
    <para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/20a.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+	<imageobject><imagedata fileref="images/20a.png"/></imageobject>
 	<textobject><phrase>20a</phrase></textobject>
 </mediaobject>
 
@@ -921,7 +921,7 @@ typedef __be32 xfs_inobt_ptr_t;
    <para>And a 2-level inode B+tree:</para>
    <para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/20b.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+	<imageobject><imagedata fileref="images/20b.png"/></imageobject>
 	<textobject><phrase>20b</phrase></textobject>
 </mediaobject>
 
diff --git a/XFS_Filesystem_Structure/en-US/Data_Extents.xml b/XFS_Filesystem_Structure/en-US/Data_Extents.xml
index 248ac70..9af8ce7 100644
--- a/XFS_Filesystem_Structure/en-US/Data_Extents.xml
+++ b/XFS_Filesystem_Structure/en-US/Data_Extents.xml
@@ -9,7 +9,7 @@
    <para>An extent is 128 bits in size and uses the following packed layout:</para>
    <para>
       <mediaobject>
-      	<imageobject><imagedata fileref="images/31.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/31.png"/></imageobject>
       	<textobject><phrase>30</phrase></textobject>
       </mediaobject>
       
@@ -62,7 +62,7 @@ typedef enum {
       
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/32.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/32.png"/></imageobject>
       	<textobject><phrase>32</phrase></textobject>
       </mediaobject>
       
@@ -111,12 +111,12 @@ u.bmx[0-2] = [startoff,startblock,blockcount,extentflag]
 </programlisting>
    <para>Raw disk version of the inode with the third extent highlighted (<command>di_u</command> always starts at offset 0x64):</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/33a.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/33a.png"/></imageobject>
 	<textobject><phrase>code33a</phrase></textobject>
 </mediaobject>
    <para>We can expand the highlighted section into the following bit array from MSB to LSB with the file offset and the block count highlighted:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/33b.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/33b.png"/></imageobject>
 	<textobject><phrase>code33b</phrase></textobject>
 </mediaobject>
 
@@ -213,7 +213,7 @@ typedef struct xfs_btree_lblock {
       
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/35.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/35.png"/></imageobject>
       	<textobject><phrase>35</phrase></textobject>
       </mediaobject>
       
@@ -240,7 +240,7 @@ typedef struct xfs_btree_lblock {
       
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/36.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/36.png"/></imageobject>
       	<textobject><phrase></phrase></textobject>
       </mediaobject>
       
diff --git a/XFS_Filesystem_Structure/en-US/Directories.xml b/XFS_Filesystem_Structure/en-US/Directories.xml
index 97e2195..e0a7779 100644
--- a/XFS_Filesystem_Structure/en-US/Directories.xml
+++ b/XFS_Filesystem_Structure/en-US/Directories.xml
@@ -105,7 +105,7 @@ typedef struct xfs_dir2_sf_entry {
 		</programlisting>
 	<para>
       <mediaobject>
-      	<imageobject><imagedata fileref="images/39.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/39.png"/></imageobject>
       	<textobject><phrase>39</phrase></textobject>
       </mediaobject>
       
@@ -169,7 +169,7 @@ u.sfdir2.list[3].inumber.i4 = 25165956
 </programlisting>
    <para>The raw data on disk with the first entry highlighted. The six byte header precedes the first entry:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/40.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/40.png"/></imageobject>
 	<textobject><phrase>code40</phrase></textobject>
 </mediaobject>
    <para>Next, an entry is deleted (frame000001.tst), and any entries after the deleted entry are moved or compacted to "cover" the hole:</para>
@@ -286,7 +286,7 @@ typedef struct xfs_dir2_block_tail {
 	   <para>
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/43.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/43.png"/></imageobject>
       	<textobject><phrase>43</phrase></textobject>
       </mediaobject>
       
@@ -464,7 +464,7 @@ btail.stale = 1
 </programlisting>
    <para>A new "bestfree" value is added for the entry, the start of the entry is marked as unused with 0xffff (which overwrites the inode number for an actual entry), and the length of the space. The tag remains intact at the <command>offset+length - sizeof(tag)</command>. The address for the hash is also cleared. The affected areas are highlighted below:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/46.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/46.png"/></imageobject>
 	<textobject><phrase>code46</phrase></textobject>
 </mediaobject>
 
@@ -536,7 +536,7 @@ typedef struct xfs_da_blkinfo {
          <para>The size of the bests array is specified by the tail.bestcount which is also the number of "data" blocks for  the directory. The bests array maintains each data block's <command>bestfree[0].length</command> value.</para>
 		<para>
 			<mediaobject>
-				<imageobject><imagedata fileref="images/48.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+				<imageobject><imagedata fileref="images/48.png"/></imageobject>
 				<textobject><phrase>48</phrase></textobject>
 			</mediaobject>
 			
@@ -837,7 +837,7 @@ typedef struct xfs_da_intnode {
          <para>The freeindex's <command>hdr.nvalid</command> should always be the same as the number of allocated data directory blocks containing name/inode data and will always be less than or equal to <command>hdr.nused. hdr.nused</command> should be the same as the index of the last data directory block plus one (i.e. when the last data block is freed, <command>nused</command> and <command>nvalid</command> are decremented).</para>
 			<para>
 				<mediaobject>
-					<imageobject><imagedata fileref="images/54.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+					<imageobject><imagedata fileref="images/54.png"/></imageobject>
 					<textobject><phrase>54</phrase></textobject>
 				</mediaobject>
 				
@@ -1003,7 +1003,7 @@ fbests[0-4] = 0:0x10 1:0x10 2:0x10 3:0x10 4:0x3f50
    <para>Like the Leaf Directory (<xref linkend="Leaf_Directories"/>), each of the <command>fbests</command> values correspond to each data block's <command>bestfree[0].length</command> value. </para>
    <para>The raw disk layout, old data is not cleared after the array. The fbests array is highlighted:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/57.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/57.png"/></imageobject>
 	<textobject><phrase>code57</phrase></textobject>
 </mediaobject>
    <para>TODO: Example with a hole in the middle</para></section>
@@ -1124,7 +1124,7 @@ nbtree[0-318] = [hashval,before] 0:[0x70b14711,8388919] ...
 </programlisting>
    <para>The leaves at each the end of a node always point to the end leaves in adjacent nodes. Directory block 8388928 forward pointer is to block 8388919, and vice versa as highlighted in the following example:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/60.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/60.png"/></imageobject>
 	<textobject><phrase>code60</phrase></textobject>
 </mediaobject></section>
 
diff --git a/XFS_Filesystem_Structure/en-US/Extended_Attributes.xml b/XFS_Filesystem_Structure/en-US/Extended_Attributes.xml
index d0bdb5b..deaa433 100644
--- a/XFS_Filesystem_Structure/en-US/Extended_Attributes.xml
+++ b/XFS_Filesystem_Structure/en-US/Extended_Attributes.xml
@@ -36,7 +36,7 @@ typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
    <para>
       
 		<mediaobject>
-			<imageobject><imagedata fileref="images/64.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+			<imageobject><imagedata fileref="images/64.png"/></imageobject>
 			<textobject><phrase>64</phrase></textobject>
 		</mediaobject>
 		
@@ -118,7 +118,7 @@ a.sfattr.list[1].value = "val1"
    <para>We can determine the actual inode offset to be 220 (15 x 8 + 100) or <command>0xdc</command>.</para>
    <para>Examining the raw dump, the second attribute is highlighted:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/65.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/65.png"/></imageobject>
 	<textobject><phrase>code65</phrase></textobject>
 </mediaobject>
    <para>Adding another attribute with attr1, the format is converted to extents and <command>di_forkoff</command> remains unchanged (and all those zeros in the dump above remain unused):</para>
@@ -173,7 +173,7 @@ a.sfattr.list[1].value = "val1"
 </programlisting>
    <para>Another attribute is added:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/66.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/66.png"/></imageobject>
 	<textobject><phrase>code66</phrase></textobject>
 </mediaobject>
    <para>One more is added:</para>
@@ -211,7 +211,7 @@ a.sfattr.list[3].value = "contents"
 </programlisting>
    <para>A raw dump is shown to compare with the attr1 dump on a prior page, the header is highlighted:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/67.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/67.png"/></imageobject>
 	<textobject><phrase>code67</phrase></textobject>
 </mediaobject>
    <para>It can be clearly seen that attr2 allows many more attributes to be stored in an inode before they are moved to another filesystem block.</para></section>
@@ -280,7 +280,7 @@ typedef struct xfs_attr_leafblock  {
       
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/69.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/69.png"/></imageobject>
       	<textobject><phrase>69</phrase></textobject>
       </mediaobject>
       
@@ -387,7 +387,7 @@ nvlist[2].name = "big_attr"
    <para>A raw disk dump shows the attributes. The last attribute added is highlighted (offset 4044 or 0xfcc):</para>
  <para>
 <inlinemediaobject>
-	<imageobject><imagedata fileref="images/code/71.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/71.png"/></imageobject>
 	<textobject><phrase>c</phrase></textobject>
 </inlinemediaobject>
 </para>
@@ -410,7 +410,7 @@ nvlist[2].name = "big_attr"
       
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/72.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/72.png"/></imageobject>
       	<textobject><phrase>72</phrase></textobject>
       </mediaobject>
       
@@ -467,12 +467,12 @@ xfs_db&gt; hash attribute_267
 
    <para>In the root btree node, this falls between <command>0x3437922e</command> and <command>0x3437d22a</command>, therefore leaf 11 or attribute block 5 will contain the entry.</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/73-74.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/73-74.png"/></imageobject>
 	<textobject><phrase>code73-74</phrase></textobject>
 </mediaobject>
    <para>Each of the hash entries has <command>XFS_ATTR_LOCAL</command> flag set (1), which means the attribute's value follows immediately after the name. Raw disk of the name/value pair at offset 2864 (0xb30), highlighted with "value_267\d" following immediately after the name:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/74.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/74.png"/></imageobject>
 	<textobject><phrase>code74</phrase></textobject>
 </mediaobject>
    <para>Each entry starts on a 32-bit (4 byte) boundary, therefore the highlighted entry has 2 unused bytes after it.</para>
diff --git a/XFS_Filesystem_Structure/en-US/Internal_Inodes.xml b/XFS_Filesystem_Structure/en-US/Internal_Inodes.xml
index b42a4a8..ac82884 100644
--- a/XFS_Filesystem_Structure/en-US/Internal_Inodes.xml
+++ b/XFS_Filesystem_Structure/en-US/Internal_Inodes.xml
@@ -23,7 +23,7 @@
    </itemizedlist>
 	<para>
 		<mediaobject>
-			<imageobject><imagedata fileref="images/76.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+			<imageobject><imagedata fileref="images/76.png"/></imageobject>
 			<textobject><phrase>76</phrase></textobject>
 		</mediaobject>
 		
diff --git a/XFS_Filesystem_Structure/en-US/On-disk_Inode.xml b/XFS_Filesystem_Structure/en-US/On-disk_Inode.xml
index 9acdc8e..5b7c926 100644
--- a/XFS_Filesystem_Structure/en-US/On-disk_Inode.xml
+++ b/XFS_Filesystem_Structure/en-US/On-disk_Inode.xml
@@ -8,7 +8,7 @@
    <para>An inode is divided into 3 parts:</para>
    <para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/23.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+	<imageobject><imagedata fileref="images/23.png"/></imageobject>
 	<textobject><phrase>23</phrase></textobject>
 </mediaobject>
 
@@ -344,7 +344,7 @@ typedef struct xfs_timestamp {
    <para>
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/28.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/28.png"/></imageobject>
       	<textobject><phrase>28</phrase></textobject>
       </mediaobject>
       
@@ -431,7 +431,7 @@ typedef struct xfs_timestamp {
    <para>The following diagram compares the two versions:</para>
    <para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/30.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+	<imageobject><imagedata fileref="images/30.png"/></imageobject>
 	<textobject><phrase>30</phrase></textobject>
 </mediaobject>
 
diff --git a/XFS_Filesystem_Structure/en-US/Symbolic_Links.xml b/XFS_Filesystem_Structure/en-US/Symbolic_Links.xml
index 9ef09ed..76c69a5 100644
--- a/XFS_Filesystem_Structure/en-US/Symbolic_Links.xml
+++ b/XFS_Filesystem_Structure/en-US/Symbolic_Links.xml
@@ -10,7 +10,7 @@
    <para>Symbolic links are stored with the "local" <command>di_format</command> if the symbolic link can fit within the inode's data fork. The link data is an array of characters (<command>di_symlink</command> array in the data fork union).</para>
    <para>
       <mediaobject>
-      	<imageobject><imagedata fileref="images/61.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/61.png"/></imageobject>
       	<textobject><phrase>61</phrase></textobject>
       </mediaobject>
       
@@ -36,7 +36,7 @@ u.symlink = "small_target"
 </programlisting>
    <para>Raw on-disk data with the link contents highlighted:</para>
 <mediaobject>
-	<imageobject><imagedata fileref="images/code/61.png" format="PNG" /></imageobject>
+	<imageobject><imagedata fileref="images/code/61.png"/></imageobject>
 	<textobject><phrase>code61</phrase></textobject>
 </mediaobject>
 </section>
@@ -48,7 +48,7 @@ u.symlink = "small_target"
    <para>
       
       <mediaobject>
-      	<imageobject><imagedata fileref="images/62.png" format="PNG" width="100%" scalefit="0"/></imageobject>
+      	<imageobject><imagedata fileref="images/62.png"/></imageobject>
       	<textobject><phrase>62</phrase></textobject>
       </mediaobject>
       

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
