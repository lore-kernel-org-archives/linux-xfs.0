Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59JCkLV054258 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 14:12:46 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA0FD8F80FE
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 12:13:04 -0700 (PDT)
Message-Id: <186A4169-077B-4009-8D7B-7DB92CC06644@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A2EAAAC.1010103@redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests: enable test 080 for LInux
Date: Tue, 9 Jun 2009 14:13:04 -0500
References: <4A2EA257.9000702@redhat.com>
	<20090609182801.GA12057@infradead.org>
	<4A2EAAAC.1010103@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>


On Jun 9, 2009, at 1:32 PM, Eric Sandeen wrote:

> Christoph Hellwig wrote:
>
>> That last line of the comment should be removed I think.
>>
>> Given that IRIX doesn't work we should just remove it from  
>> _supported_os
>> above.
>>
> Heh, good points, here's the revised one:
>
> Seems to work here...  Anyone know why it's disabled?
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> diff --git a/080 b/080
> index e9721ad..dc51c59 100755
> --- a/080
> +++ b/080
> @@ -47,14 +47,11 @@ _supported_fs xfs
>
> # Apparently should be able to work on IRIX,
> # but not at the moment.
> -# It does not work on Linux due to some locking issues...
> -_supported_os IRIX
> -
> -[ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"
> +_supported_os Linux
>
> _setup_testdir
>
> -#quiet=-q
> +quiet=-q
> clean=-c
>
> export here
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
