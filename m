Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E52997F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 08:18:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E8BDAC002
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 06:18:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id a5n4ikko1T9ZhTYU for
	<xfs@oss.sgi.com>; Thu, 24 Oct 2013 06:18:05 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9ODI5xE006658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 09:18:05 -0400
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with
	ESMTP id r9ODI12X023466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 09:18:04 -0400
Date: Thu, 24 Oct 2013 11:18:01 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests: src/feature.c: print a number of online CPUs
Message-ID: <20131024131800.GA27701@orion.maiolino.org>
References: <20131023213152.GP2797@dastard>
	<1382604998-11037-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<20131024104042.GT2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024104042.GT2797@dastard>
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

Hi Dave,

I'm not sure about setting the default to 1 cpu might me a good behavior. My
apologies if I'm saying something wrong, but, if the 'tester' are trying to do
some test trusting on the amount of cpus, it might not be a good behavior.
I was thinking, how about issue an error message if xfstests can't properly
detect the amount of cpus from the system, and add any kind of usage option to
specify the numbers of cpus? So in case of a error while detecting the amount of
cpus.


> 
> Actually, I'd say we shoul default to 1 cpu if we can't get the
> number of CPUs. Clearly we have at least one if we can run this
> code. :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
