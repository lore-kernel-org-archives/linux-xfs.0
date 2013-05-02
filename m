Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B17AF7F69
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 10:39:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B597AC003
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 08:39:01 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id Lh7bNAdeFu0X2Nuh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 08:39:00 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 2 May 2013 11:38:59 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 5D1876E8040
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 11:38:54 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r42Fcv8e326440 for <xfs@oss.sgi.com>; Thu, 2 May 2013 11:38:57 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r42FcsQ4012445 for <xfs@oss.sgi.com>; Thu, 2 May 2013 12:38:56 -0300
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <51827DDF.4050708@redhat.com>
References: <51827DDF.4050708@redhat.com>
Date: Thu, 02 May 2013 10:38:52 -0500
Message-ID: <1367509132.4098.86.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, 2013-05-02 at 09:53 -0500, Eric Sandeen wrote:
> Pull all of the old xfs_check script into common/rc:_xfs_check()
> so that it properly handles all options, including external log
> devices.

I see changes only related to USAGE. iiuc, log devices are handled
properly by current code.

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/common/rc b/common/rc
> index 19a0e18..b47a53e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -393,8 +393,8 @@ _xfs_check()
>  {
>      OPTS=" "
>      DBOPTS=" "
> +    USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
> 
> -    OPTIND=1
>      while getopts "b:fi:l:stvV" c
>      do
>          case $c in
> @@ -410,8 +410,17 @@ _xfs_check()
>                  ;;
>          esac
>      done
> -    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
> -    return $?
> +    set -- extra $@
> +    shift $OPTIND
> +    case $# in
> +        1)    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
> +               status=$?
> +               ;;
> +        2)    echo $USAGE 1>&1
> +              status=2
> +              ;;
> +    esac
> +    return $status
>  }
> 
>  _setup_large_ext4_fs()
> 
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
