Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38F207F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 11:12:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8FE1AC002
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 09:12:08 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	xnxXK8pdWxG9dHDM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 09:12:07 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id c13so14363733ieb.10
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 09:12:07 -0700 (PDT)
Message-ID: <519A4B40.2050704@gmail.com>
Date: Mon, 20 May 2013 12:11:44 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] xfsprogs: more CRC support patches
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<1369032783-24973-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1369032783-24973-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/20/2013 02:52 AM, Dave Chinner wrote:
> [ well, really patches 31..36 :) ]
>
> Hi folks,
>
> More work on top of the original series of 30 patches, including
> xfs_db support for parsing the v3 directory format.
>
> Note that there are also two patches in here that convert both
> xfs_db and xfs_repair to use the libxfs directory block type
> definitions. While it may have once been convenient for them to have
> a basic definition, it does not lend itself to making the code
> support the v3 format quickly and concisely. Reusing the
> libxfs/kernel structure definitions and abstraction means that the
> code quickly becomes v3 aware and has just works.
>
> Right now this patchset and the current kernel patchset (all the
> attr fixes) runs through xfstests quite far on a 4k block size
> filesystem - all the generic tests pass, and most of the XFS
> specific tests that don't rely on write or attr output support in
> xfs_db also pass.
>
> I'll get the attr db support done tomorrow.....
>
> Cheers,
>
> Dave.

This makes some improvement to the setup here: xfs/041 no longer 
triggers a sure-fire "args->op_flags & XFS_DA_OP_OKNOENT" assertion. 
This will take a re-review on my part of the xfs/[0-9][0-9][0-9] test set.

Here's how the `git am` session went, syntax removed because Ctrl-w word 
removal in bash makes the script output unworkable:

# PATCH 1
Applying: xfs_repair: always use incore header for directory block checks
# PATCH 2
Applying: xfs_db: convert directory parsing to use libxfs structure
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:94: trailing whitespace.
	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC &&
warning: 1 line adds whitespace errors.
# PATCH 3
Applying: xfs_db: factor some common dir2 field parsing code.
# PATCH 4
Applying: xfs_db: update field printing for dir crc format changes.
# PATCH 5
Applying: xfs_repair: convert directory parsing to use libxfs structure
# PATCH 6
Applying: xfs_repair: make directory freespace table CRC format aware.

Nice job!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
