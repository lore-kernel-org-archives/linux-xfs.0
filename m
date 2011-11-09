Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9KHj3j250819 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 14:17:45 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C926130404E
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 12:17:41 -0800 (PST)
Received: from [134.15.95.101] (cf-vpn-hw-arenaud-4.corp.sgi.com
	[134.15.95.101])
	by estes.americas.sgi.com (Postfix) with ESMTP id 9808470017D2
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 14:17:41 -0600 (CST)
Message-ID: <4EBADFE8.9000805@sgi.com>
Date: Wed, 09 Nov 2011 15:17:44 -0500
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: add .ltdep to .gitignore
References: <1320865438-27014-1-git-send-email-bpm@sgi.com>
In-Reply-To: <1320865438-27014-1-git-send-email-bpm@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The change look good

Reviewed-by: Alain Renaud<arenaud@sgi.com>



On 11-11-09 02:03 PM, Ben Myers wrote:
> Make git ignore all .ltdep files which are created as part of the build
> process.
>
> ~/xfsprogs # find | grep ltdep
> ./libxcmd/.ltdep
> ./libxfs/.ltdep
> ./libhandle/.ltdep
> ./libdisk/.ltdep
> ./libxlog/.ltdep
>
> Signed-off-by: Ben Myers<bpm@sgi.com>
> ---
>   .gitignore |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/.gitignore b/.gitignore
> index aa6cd35..22b4f65 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -1,6 +1,7 @@
>   # object files
>   *.o
>   .dep
> +.ltdep
>
>   # build system
>   .census

-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
