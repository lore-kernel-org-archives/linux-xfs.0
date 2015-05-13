Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 544D97F6D
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 08:59:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F313FAC003
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 06:59:26 -0700 (PDT)
Received: from mail-qk0-f171.google.com (mail-qk0-f171.google.com
	[209.85.220.171]) by cuda.sgi.com with ESMTP id
	PsJOyfrUffpreHmX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 06:59:22 -0700 (PDT)
Received: by qkgx75 with SMTP id x75so28491741qkg.1
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 06:59:21 -0700 (PDT)
Date: Wed, 13 May 2015 09:59:19 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150513135919.GS11388@htj.duckdns.org>
References: <1431474754-15764-1-git-send-email-david@fromorbit.com>
	<1431474754-15764-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1431474754-15764-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello, Dave.

On Wed, May 13, 2015 at 09:52:33AM +1000, Dave Chinner wrote:
> @@ -116,6 +121,12 @@ static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
>  		return 0;
>  }
>  
> +static inline int
> +percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
> +{
> +	return percpu_counter_compare(fbc, rhs);
> +}

I don't think this is right.  Looks fine to me otherwise.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
