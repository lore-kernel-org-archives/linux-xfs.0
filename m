Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 23:05:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5265nwL011526
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 23:05:51 -0700
Subject: Re: REVIEW: Zero uninitialised xfs_da_args structure in xfs_dir2.c
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ub3wttk53jf8g2@pc-bnaujok.melbourne.sgi.com> <20080602055028.GA1629@infradead.org>
Date: Mon, 02 Jun 2008 16:08:23 +1000
Message-ID: <op.ub3xz9ui3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080602055028.GA1629@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 02 Jun 2008 15:50:28 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, Jun 02, 2008 at 03:42:55PM +1000, Barry Naujok wrote:
>> In particular, this patch fixes a problem in the xfs_dir2_remove and
>> xfs_dir2_replace paths which internally can call a lookup function
>> which will use args->cmpresult which is uninitialised.
>
>> Index: 2.6.x-xfs/fs/xfs/xfs_dir2.c
>> ===================================================================
>> --- 2.6.x-xfs.orig/fs/xfs/xfs_dir2.c
>> +++ 2.6.x-xfs/fs/xfs/xfs_dir2.c
>> @@ -213,6 +213,7 @@ xfs_dir_createname(
>>  	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
>>  		return rval;
>>  	XFS_STATS_INC(xs_dir_create);
>> +	memset(&args, 0, sizeof(xfs_da_args_t));
>>
>>  	args.name = name->name;
>>  	args.namelen = name->len;
>
> Doing these memsets looks good.  Stylisticly I'd rather put them
> directly in front of the intialization for the actually used args
> fields.

I agree, so here's the alternative patch which makes them all
consistent:

Index: 2.6.x-xfs/fs/xfs/xfs_dir2.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2.c
+++ 2.6.x-xfs/fs/xfs/xfs_dir2.c
@@ -214,6 +214,7 @@ xfs_dir_createname(
  		return rval;
  	XFS_STATS_INC(xs_dir_create);

+	memset(&args, 0, sizeof(xfs_da_args_t));
  	args.name = name->name;
  	args.namelen = name->len;
  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
@@ -286,8 +287,8 @@ xfs_dir_lookup(

  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
  	XFS_STATS_INC(xs_dir_lookup);
-	memset(&args, 0, sizeof(xfs_da_args_t));

+	memset(&args, 0, sizeof(xfs_da_args_t));
  	args.name = name->name;
  	args.namelen = name->len;
  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
@@ -297,7 +298,6 @@ xfs_dir_lookup(
  	args.op_flags = XFS_DA_OP_OKNOENT;
  	if (ci_name)
  		args.op_flags |= XFS_DA_OP_CILOOKUP;
-	args.cmpresult = XFS_CMP_DIFFERENT;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_lookup(&args);
@@ -343,6 +343,7 @@ xfs_dir_removename(
  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
  	XFS_STATS_INC(xs_dir_remove);

+	memset(&args, 0, sizeof(xfs_da_args_t));
  	args.name = name->name;
  	args.namelen = name->len;
  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
@@ -353,7 +354,6 @@ xfs_dir_removename(
  	args.total = total;
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
-	args.op_flags = 0;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_removename(&args);
@@ -426,6 +426,7 @@ xfs_dir_replace(
  	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
  		return rval;

+	memset(&args, 0, sizeof(xfs_da_args_t));
  	args.name = name->name;
  	args.namelen = name->len;
  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
@@ -436,7 +437,6 @@ xfs_dir_replace(
  	args.total = total;
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
-	args.op_flags = 0;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_replace(&args);
@@ -472,8 +472,8 @@ xfs_dir_canenter(
  		return 0;

  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
-	memset(&args, 0, sizeof(xfs_da_args_t));

+	memset(&args, 0, sizeof(xfs_da_args_t));
  	args.name = name->name;
  	args.namelen = name->len;
  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
