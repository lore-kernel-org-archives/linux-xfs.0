Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59ISuwj052491 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:28:56 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 541758F80FF
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 11:29:14 -0700 (PDT)
Message-Id: <8096F303-071C-4D31-BAF8-D0D66A7DC0E9@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A2EA257.9000702@redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests: enable test 080 for LInux
Date: Tue, 9 Jun 2009 13:29:13 -0500
References: <4A2EA257.9000702@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>


On Jun 9, 2009, at 12:56 PM, Eric Sandeen wrote:

> Seems to work here...  Anyone know why it's disabled?
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>
> diff --git a/080 b/080
> index e9721ad..1794a4c 100755
> --- a/080
> +++ b/080
> @@ -48,13 +48,13 @@ _supported_fs xfs
> # Apparently should be able to work on IRIX,
> # but not at the moment.
> # It does not work on Linux due to some locking issues...
> -_supported_os IRIX
> +_supported_os IRIX Linux
>
> [ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"

How do these two statements fit together. If it doesn't
work on IRIX, should we drop 'IRIX' from _supported_os ?

Felix

>
>
> _setup_testdir
>
> -#quiet=-q
> +quiet=-q
> clean=-c
>
> export here
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
