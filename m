Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEEA87F50
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 17:38:18 -0500 (CDT)
Message-ID: <522664D9.8010504@sgi.com>
Date: Tue, 03 Sep 2013 17:38:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<5224C4E9.8080604@sgi.com> <20130902222004.GI12779@dastard>
	<5225DF07.4080509@sgi.com> <20130903200401.GF23571@dastard>
	<52264AA0.4010501@sgi.com> <20130903211643.GG23571@dastard>
In-Reply-To: <20130903211643.GG23571@dastard>
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

On 09/03/13 16:16, Dave Chinner wrote:
> Let's just quote Linus from 2003, shall we:
>
> http://yarchive.net/comp/linux/vmalloc.html
>
> |>  I think it'd make more sense to only use vmalloc when it's explicitly
> |>  too big for kmalloc - or simply switch on num_online_cpus>  100 or
> |>  whatever a sensible cutoff is (ie nobody but you would ever see this ;-))
> |
> | No, please please please don't do these things.
> |
> | vmalloc() is NOT SOMETHING YOU SHOULD EVER USE! It's only valid for when
> | you_need_  a big array, and you don't have any choice. It's slow, and it's
> | a very restricted resource: it's a global resource that is literally
> | restricted to a few tens of megabytes. It should be_very_  carefully used.
> |
> | There are basically no valid new uses of it. There's a few valid legacy
> | users (I think the file descriptor array), and there are some drivers that
> | use it (which is crap, but drivers are drivers), and it's_really_  valid
> | only for modules. Nothing else.
> |
> | Basically: if you think you need more memory than a kmalloc() can give,
> | you need to re-organize your data structures. To either not need a big
> | area, or to be able to allocate it in chunks.
> |
> | 		Linus
>
> Linus will say exactly the same thing today....

And that is very very sad that is it funny.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
