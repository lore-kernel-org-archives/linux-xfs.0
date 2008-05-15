Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:39:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F6dMJr019676
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:39:24 -0700
Message-ID: <482BDAC1.7070407@sgi.com>
Date: Thu, 15 May 2008 16:40:01 +1000
From: Tim Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] don't run test 167 if killall is not installed
References: <20080515053918.GA16530@lst.de>
In-Reply-To: <20080515053918.GA16530@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Test 167 will leave runaway fsstress processes around in case killall is
> not installed and thus make all following tests fail.  This patch checks
> for killall beeing installed and error out otherwise.
> 
> 

Looks reasonable.

However:

* could use set_prog_path like we do in common.config.

* I wonder if one could use "kill -$pgid" on the process group
for fsstress instead of killall (I've never tried it :).

--Tim

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests/167
> ===================================================================
> RCS file: /cvs/xfs-cmds/xfstests/167,v
> retrieving revision 1.3
> diff -u -p -r1.3 167
> --- xfstests/167	2 Aug 2007 16:19:56 -0000	1.3
> +++ xfstests/167	15 May 2008 05:34:20 -0000
> @@ -13,6 +13,7 @@ owner=dgc@sgi.com
>  seq=`basename $0`
>  echo "QA output created by $seq"
>  
> +killall="/usr/bin/killall"
>  here=`pwd`
>  tmp=/tmp/$$
>  rm -f $seq.full
> @@ -43,6 +44,8 @@ workout()
>  _supported_fs xfs
>  _supported_os Linux
>  
> +[ -x $killall ] || _notrun "$killall executable not found"
> +
>  _setup_testdir
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> 
