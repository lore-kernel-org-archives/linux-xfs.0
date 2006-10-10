Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 20:08:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9A37haG010652
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 20:07:44 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4601048BD11
	for <xfs@oss.sgi.com>; Mon,  9 Oct 2006 20:07:01 -0700 (PDT)
Message-ID: <452B0E53.2070507@sandeen.net>
Date: Mon, 09 Oct 2006 22:06:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs vs. lockdep
References: <452A8DE2.4000608@sandeen.net> <452ADCE9.2070402@sgi.com>
In-Reply-To: <452ADCE9.2070402@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: xfs@oss.sgi.com

Vlad Apostolov wrote:

> Hi Eric,
> 
> Could you please provide some more information. What kernel, test case 
> and call stack at the time of the crash.
> 
> Thanks,
> Vlad

Vlad, for reference, this was a very recent FC6 test kernel, which has lockdep & 
slab debugging on.  Oopsing is as simple as mounting & umounting.  It dies in 
lockdep code.

See also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=209062

-Eric
