Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 21:03:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3343DjF031328
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 21:03:15 -0700
Date: Thu, 03 Apr 2008 14:04:05 +1000
Subject: Re: [PATCH 3/7] XFS: Refactor node format directory lookup/addname
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.380299192@chook.melbourne.sgi.com> <20080403015122.GE5211@josefsipek.net>
Message-ID: <op.t80n83u33jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080403015122.GE5211@josefsipek.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, 03 Apr 2008 11:51:22 +1000, Josef 'Jeff' Sipek  
<jeffpc@josefsipek.net> wrote:

>> +static int
>> +xfs_dir2_leafn_lookup_for_entry(
>> +	xfs_dabuf_t		*bp,		/* leaf buffer */
>> +	xfs_da_args_t		*args,		/* operation arguments */
>> +	int			*indexp,	/* out: leaf entry index */
>> +	xfs_da_state_t		*state)		/* state to fill in */
>> +{
>> +	xfs_dabuf_t		*curbp;		/* current data/free buffer */
>> +	xfs_dir2_db_t		curdb;		/* current data block number */
>> +	xfs_dir2_data_entry_t	*dep;		/* data block entry */
>> +	xfs_inode_t		*dp;		/* incore directory inode */
>> +	int			error;		/* error return value */
>> +	int			index;		/* leaf entry index */
>> +	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>> +	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
>> +	xfs_mount_t		*mp;		/* filesystem mount point */
>> +	xfs_dir2_db_t		newdb;		/* new data block number */
>> +	xfs_trans_t		*tp;		/* transaction pointer */
>> +	xfs_dacmp_t		cmp;		/* comparison result */
>> +	xfs_dabuf_t		*ci_bp = NULL;	/* buffer with CI match */
>
> Did you try to check the stack usage (scripts/checkstack.pl)?

on x86_64:

nameops.patch
   -> no difference

ascii_ci.patch
   -> no difference

refactor_leafn_lookup.patch (this one)
   -> no difference

return_name.patch
   -> xfs_dir_lookup from 152 down to 144 :)

unicode_ci.patch
   -> xfs_mkdir from 152 down to 136 :)
   -> new xfs_unicode_read_cft @ 120

nls_support.patch
   -> xfs_dir2_leaf_getdents from 136 up to 200 (ouch!)
   -> xfs_mkdir from 136 back to 152!
   -> xfs_create from 152 up to 168
   -> xfs_rmdir from 104 down to < 100?

This seems to be better than the stack usage Eric posted back in
response to my last patch set.
