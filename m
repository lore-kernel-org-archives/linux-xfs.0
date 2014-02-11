Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF80D7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 23:33:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7342BAC00B
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 21:33:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OUDxZr26Ye5ug974 for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 21:33:37 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WD5yM-0004vL-HB
	for xfs@oss.sgi.com; Tue, 11 Feb 2014 16:33:30 +1100
Date: Tue, 11 Feb 2014 16:33:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs-documentation: master branch updated to 8421062
Message-ID: <20140211053330.GB13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi Folks,

The XFS Documentation repository at
git://oss.sgi.com/xfs/cmds/xfs-documentation has just been updated.

The new head of the master branch is commit:

8421062 doc: import XFS Filesystem Structure documentation

This is the first of the major documents that we need to convert to
asciidoc to make them easier to maintain and update. The build
system requires the a2x asciidoc toolchain, which requires the
entire docbook build infrastructure. Essentially the first build
step is to turn the asciidoc into docbook XML, and it is then built
into the destination format from there.

Essentially, this gives us the ability to include all sorts of
docbook metadata in XML format to the document, while keeping the
actual contents of the document in asciidoc markup. Hence we should
be able to make this build and document structure work (eventually)
with distro documentation toolchains like Publican.

As it is, we really need to convert the rest of the documentation
to asciidoc format and updating it to be current before we go much
further. Ideally, I'd like to convert a significant amount of the
documentation on the xfs.org wiki to asciidoc (e.g. the FAQ, all the
design docs, etc) and replace the wiki contents with the html files
built from this repository.

And finally, with asciidoc being able to generate manpage format
output, I'd really like to convert a bunch of the man pages into
asciidoc so that we can build html/pdf user manuals fromteh same
source as we generate man pages. A good example of this is the
xfs_db man page, which describes just about every command xfs_db
supports....

Anyway, try it out, have a look at the built documentation, the
structure of documentation source, etc. I'm interested to see what
people think and what ideas people have for being able to skin the
documentation appropriately....

Cheers,

Dave.

New Commits:

Dave Chinner (1):
      [8421062] doc: import XFS Filesystem Structure documentation


Code Diffstat:

 design/Makefile                                    |   26 +-
 design/XFS_Filesystem_Structure/Makefile           |   34 +
 .../allocation_groups.asciidoc                     |  782 ++++
 .../XFS_Filesystem_Structure/common_types.asciidoc |   49 +
 .../XFS_Filesystem_Structure/data_extents.asciidoc |  247 ++
 .../XFS_Filesystem_Structure/directories.asciidoc  | 1193 ++++++
 design/XFS_Filesystem_Structure/docinfo.xml        |   72 +
 .../extended_attributes.asciidoc                   |  609 +++
 design/XFS_Filesystem_Structure/images/15a.png     |  Bin 0 -> 50788 bytes
 design/XFS_Filesystem_Structure/images/15b.png     |  Bin 0 -> 95395 bytes
 design/XFS_Filesystem_Structure/images/16.png      |  Bin 0 -> 36702 bytes
 design/XFS_Filesystem_Structure/images/18.png      |  Bin 0 -> 23260 bytes
 design/XFS_Filesystem_Structure/images/20a.png     |  Bin 0 -> 72052 bytes
 design/XFS_Filesystem_Structure/images/20b.png     |  Bin 0 -> 91930 bytes
 design/XFS_Filesystem_Structure/images/23.png      |  Bin 0 -> 19185 bytes
 design/XFS_Filesystem_Structure/images/28.png      |  Bin 0 -> 48498 bytes
 design/XFS_Filesystem_Structure/images/30.png      |  Bin 0 -> 27246 bytes
 design/XFS_Filesystem_Structure/images/31.png      |  Bin 0 -> 10652 bytes
 design/XFS_Filesystem_Structure/images/32.png      |  Bin 0 -> 60716 bytes
 design/XFS_Filesystem_Structure/images/35.png      |  Bin 0 -> 167184 bytes
 design/XFS_Filesystem_Structure/images/36.png      |  Bin 0 -> 188957 bytes
 design/XFS_Filesystem_Structure/images/39.png      |  Bin 0 -> 48607 bytes
 design/XFS_Filesystem_Structure/images/43.png      |  Bin 0 -> 103425 bytes
 design/XFS_Filesystem_Structure/images/48.png      |  Bin 0 -> 145519 bytes
 design/XFS_Filesystem_Structure/images/54.png      |  Bin 0 -> 217092 bytes
 design/XFS_Filesystem_Structure/images/6.png       |  Bin 0 -> 87067 bytes
 design/XFS_Filesystem_Structure/images/61.png      |  Bin 0 -> 33415 bytes
 design/XFS_Filesystem_Structure/images/62.png      |  Bin 0 -> 53958 bytes
 design/XFS_Filesystem_Structure/images/64.png      |  Bin 0 -> 49003 bytes
 design/XFS_Filesystem_Structure/images/69.png      |  Bin 0 -> 128382 bytes
 design/XFS_Filesystem_Structure/images/72.png      |  Bin 0 -> 138179 bytes
 design/XFS_Filesystem_Structure/images/76.png      |  Bin 0 -> 31266 bytes
 .../XFS_Filesystem_Structure/images/code/33a.png   |  Bin 0 -> 106484 bytes
 .../XFS_Filesystem_Structure/images/code/33b.png   |  Bin 0 -> 40229 bytes
 design/XFS_Filesystem_Structure/images/code/40.png |  Bin 0 -> 94094 bytes
 design/XFS_Filesystem_Structure/images/code/46.png |  Bin 0 -> 78484 bytes
 design/XFS_Filesystem_Structure/images/code/57.png |  Bin 0 -> 17987 bytes
 design/XFS_Filesystem_Structure/images/code/60.png |  Bin 0 -> 32907 bytes
 design/XFS_Filesystem_Structure/images/code/61.png |  Bin 0 -> 54687 bytes
 design/XFS_Filesystem_Structure/images/code/65.png |  Bin 0 -> 107515 bytes
 design/XFS_Filesystem_Structure/images/code/66.png |  Bin 0 -> 69316 bytes
 design/XFS_Filesystem_Structure/images/code/67.png |  Bin 0 -> 109738 bytes
 design/XFS_Filesystem_Structure/images/code/71.png |  Bin 0 -> 62675 bytes
 .../XFS_Filesystem_Structure/images/code/73-74.png |  Bin 0 -> 153732 bytes
 design/XFS_Filesystem_Structure/images/code/74.png |  Bin 0 -> 62210 bytes
 .../images/code/SVG/33a.svg                        |  185 +
 .../images/code/SVG/33b.svg                        |  158 +
 .../images/code/SVG/40.svg                         |  177 +
 .../images/code/SVG/46.svg                         |  197 +
 .../images/code/SVG/57.svg                         |  129 +
 .../images/code/SVG/60.svg                         |  182 +
 .../images/code/SVG/61.svg                         |  157 +
 .../images/code/SVG/65.svg                         |  233 ++
 .../images/code/SVG/66.svg                         |  260 ++
 .../images/code/SVG/67.svg                         |  232 ++
 .../images/code/SVG/71.svg                         |  150 +
 .../images/code/SVG/73-74.svg                      |  364 ++
 .../images/code/SVG/74.svg                         |  201 +
 design/XFS_Filesystem_Structure/images/icon.svg    | 3936 ++++++++++++++++++++
 .../internal_inodes.asciidoc                       |  182 +
 .../journaling_log.asciidoc                        |    3 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  448 +++
 .../symbolic_links.asciidoc                        |   81 +
 .../xfs_filesystem_structure.asciidoc              |   53 +
 64 files changed, 10337 insertions(+), 3 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/Makefile
 create mode 100644 design/XFS_Filesystem_Structure/allocation_groups.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/common_types.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/data_extents.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/directories.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/docinfo.xml
 create mode 100644 design/XFS_Filesystem_Structure/extended_attributes.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/images/15a.png
 create mode 100644 design/XFS_Filesystem_Structure/images/15b.png
 create mode 100644 design/XFS_Filesystem_Structure/images/16.png
 create mode 100644 design/XFS_Filesystem_Structure/images/18.png
 create mode 100644 design/XFS_Filesystem_Structure/images/20a.png
 create mode 100644 design/XFS_Filesystem_Structure/images/20b.png
 create mode 100644 design/XFS_Filesystem_Structure/images/23.png
 create mode 100644 design/XFS_Filesystem_Structure/images/28.png
 create mode 100644 design/XFS_Filesystem_Structure/images/30.png
 create mode 100644 design/XFS_Filesystem_Structure/images/31.png
 create mode 100644 design/XFS_Filesystem_Structure/images/32.png
 create mode 100644 design/XFS_Filesystem_Structure/images/35.png
 create mode 100644 design/XFS_Filesystem_Structure/images/36.png
 create mode 100644 design/XFS_Filesystem_Structure/images/39.png
 create mode 100644 design/XFS_Filesystem_Structure/images/43.png
 create mode 100644 design/XFS_Filesystem_Structure/images/48.png
 create mode 100644 design/XFS_Filesystem_Structure/images/54.png
 create mode 100644 design/XFS_Filesystem_Structure/images/6.png
 create mode 100644 design/XFS_Filesystem_Structure/images/61.png
 create mode 100644 design/XFS_Filesystem_Structure/images/62.png
 create mode 100644 design/XFS_Filesystem_Structure/images/64.png
 create mode 100644 design/XFS_Filesystem_Structure/images/69.png
 create mode 100644 design/XFS_Filesystem_Structure/images/72.png
 create mode 100644 design/XFS_Filesystem_Structure/images/76.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/33a.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/33b.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/40.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/46.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/57.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/60.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/61.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/65.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/66.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/67.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/71.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/73-74.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/74.png
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/33a.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/33b.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/40.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/46.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/57.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/60.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/61.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/65.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/66.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/67.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/71.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/73-74.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/74.svg
 create mode 100644 design/XFS_Filesystem_Structure/images/icon.svg
 create mode 100644 design/XFS_Filesystem_Structure/internal_inodes.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/journaling_log.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/symbolic_links.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
