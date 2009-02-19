Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JGVnYZ117551 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 10:31:50 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3C9D134888
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 08:31:16 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 223Y35gTwoMzXGxA for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2009 08:31:16 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1JGVF7c001785
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:31:15 -0500
Message-ID: <499D8950.9030708@sandeen.net>
Date: Thu, 19 Feb 2009 10:31:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: libattr - severe memory leaks from attr_copy_file()
References: <499D0471.6000600@redhat.com>
In-Reply-To: <499D0471.6000600@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Zdenek Prikryl <zprikryl@redhat.com>
Cc: xfs@oss.sgi.com

Zdenek Prikryl wrote:
>> And the variable, text, is assigned straight away before any use,
>> so I missed where the problem is.
>>
>> --Tim
> 
> The memory leak is really there. Look:
> 
> 54 attr_parse_attr_conf(struct error_context *ctx)
> ...
> 66 repeat:
> 67         text = malloc(size_guess + 1);
> 68         if (!text)
> 69                 goto fail;
> 70
> 71         if ((file = fopen(ATTR_CONF, "r")) == NULL) {
> 72                 if (errno == ENOENT)
> 73                         return 0;
> 74                 goto fail;
> 75         }
> 
> Let's say that malloc() on the line 67 success, so we have text != NULL. Then,
> fopen() on the line 71 fails and errno == ENOENT. In that case
> attr_parse_attr_conf() simply returns 0, but text isn't freed. That's the point,
> where memory leaks arise. I rewrote the patch, so now is more simpler.

The patch you attached looks good to me, thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
