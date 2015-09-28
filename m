Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 038B37F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:02:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E515E30404E
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 08:01:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id immG6iyFBvPhjzRe for <xfs@oss.sgi.com>;
	Mon, 28 Sep 2015 08:01:56 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 236E56BAE239
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:01:56 -0500 (CDT)
Subject: Re: [PATCH 0/7 v8] xfs: stats in sysfs
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
	<5609561C.5040508@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56095663.6080609@sandeen.net>
Date: Mon, 28 Sep 2015 10:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <5609561C.5040508@sandeen.net>
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
To: xfs@oss.sgi.com

oops, lost a line, should have been:


On 9/28/15 10:00 AM, Eric Sandeen wrote:
> Or for a more concrete example, in patch 5 you do: 
>  for_each_possible_cpu(cpu)
> -		val += *(((__u32 *)&per_cpu(xfsstats, cpu) + idx));
> +		val += *(((__u32 *)&per_cpu(*stats, cpu) + idx));
>  return val;
> 
> and then in patch 6 you do:
> 
>  	for_each_possible_cpu(cpu)
> -		val += *(((__u32 *)&per_cpu(*stats, cpu) + idx));
> +		val += *(((__u32 *)per_cpu_ptr(stats, cpu) + idx));
> 
>  	return val;
> 
> But this is unrelated to the purpose of patch 6; it should just be fixed
> up in a modified patch 5, i.e.
> 
>  	for_each_possible_cpu(cpu)
> -		val += *(((__u32 *)&per_cpu(xfsstats, cpu) + idx));
> +		val += *(((__u32 *)per_cpu_ptr(stats, cpu) + idx));
> 	return val;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
