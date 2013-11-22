Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A6797F3F
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 15:10:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4307F8F8065
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 13:10:06 -0800 (PST)
Message-ID: <528FC827.7080100@redhat.com>
Date: Fri, 22 Nov 2013 15:09:59 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH V4] xfsprogs: update version for 3.2.0-alpha2
References: <20131118150313.940966335@sgi.com>
	<20131122183757.113479216@sgi.com>
In-Reply-To: <20131122183757.113479216@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7818644359970552058=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: rjohnston@sgi.com, xfs@oss.sgi.com

--===============7818644359970552058==
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 11/22/13, 12:37 PM, rjohnston@sgi.com wrote:
> Update the VERSION, configure.ac and doc/CHANGES file for alpha
> release, 3.2.0-alpha2
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> ---
> V4
> Updated doc/CHANGES per suggestions by Eric and Dave.
> Added SOB by Eric
> 

<snip>

>  xfsprogs-3.2.0-alpha1 (26 September 2013)
> -	- Alpha release for the purpose of testing the CRC feature during the
> -	  v3.12 kernel -rc series.
> +	- Alpha release for the purpose of testing the CRC feature in
> +	  kernels 3.10 and newer.
> +	- Remove all vestiges of old, unsupported version 1 directory code.
> +	- Add a “readdir” command to xfs_io, thanks to Brian Foster.
                ^^^       ^^
That got a bit weird, probably my fault.

Thanks,
-Eric

> +	- Fix potential segfault in xfs_repair when creating lost+found.
> +	- Zero out unused parts of on-disk superblocks during repair, to
> +	  avoid metadata verifier failures at runtime.
> +	- Add directory entry type support to mkfs.xfs and xfs_db.
> +	- Add the icreate transaction to xfs_logprint, and fix continuation
> +	  transactions.
> +	- Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
> +	- Print all AGI unlinked buckets in xfs_logprint.
> +	- Fix mkfs.xfs ENOSPC with protofile which creates a very large
> +	  directory.
> +	- Fix several Coverity-found defects, thanks to Li Zhong.
> +	- Do all file reads in xfs_fsr using O_DIRECT.
> +	- Sync up libxfs with kernel code.
> +	- Add support for concurrent group and project quota usage on CRC
> +	  enabled filesystems.
> +	- Ensure mkfs creates log sizes that are always large enough for
> +	  the configured fileystem geometry.
>  
>  xfsprogs-3.1.11 (8 May 2013)
>  	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
> @@ -35,8 +80,8 @@ xfsprogs-3.1.11 (8 May 2013)
>  	- Remove unconditional ASSERT(0) in xfs_repair.
>  	- Reduce bb_numrecs in bno/cnt btrees when log consumes all agf space.
>  	- Add depraction message for xfs_check.
> -	- xfs_quota allow user or group names beginning with digits reported by
> -	  James Carter.
> +	- xfs_quota allow user or group names beginning with digits reported
> +	  by James Carter.
>  	- Fix manpages and usage() spelling, errors and omissions.
>  	- Validate the extent count is at least within the positive
>  	  range of a signed 32 bit integer before using it.
> 
> 


--===============7818644359970552058==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7818644359970552058==--
