Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 14:38:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SLcBBJ001222
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:38:12 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEEDA55556B
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:38:11 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id 23HD9sNuay0gSmuc for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:38:11 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9SLc8YP009017
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:38:09 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SLc8mt026768
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:38:08 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9SLc72H006962
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:38:07 -0400
Message-ID: <4907863F.3030005@sandeen.net>
Date: Tue, 28 Oct 2008 16:38:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3 v3]  hook xfs to fiemap ioctl
References: <4904E0DE.3040902@sandeen.net>
In-Reply-To: <4904E0DE.3040902@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> v2: Update & resend, including some checkpatch fixes, a bugfix, and 
> incorporating some of Christoph's and Dave's comments.
> 
> v3: Address more review comments, and split into 3 patches this time.
> 
> Also, here's a very hacky (don't laugh!) test app.  I'll clean it
> up at some point  :) 
> 
> -Eric
> 

Apologies, I'm going to have to send at least one more round.  I left
out the bit where the fiemap interface lets you pass in just the header,
and no array for extents information, to simply get back an extent count.

I have a fix for that, will send later tonight.

Is there any chance of this making .28 still? :)

-Eric
