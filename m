Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F4BA7CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 11:46:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06C1BAC008
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 09:46:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kQalLikTfqYEmiF7 for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 09:46:54 -0700 (PDT)
Message-ID: <521CD7FC.1080706@sandeen.net>
Date: Tue, 27 Aug 2013 11:46:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
References: <2909046.09LYLQvZ6q@localhost.localdomain>
	<44437668.FEX1DiRokR@localhost.localdomain>
	<521B664B.7030404@redhat.com>
	<3942763.p7a9her5Nt@localhost.localdomain>
In-Reply-To: <3942763.p7a9her5Nt@localhost.localdomain>
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
To: chandan <chandan@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>, sekharan@linux.vnet.ibm.com, xfs@oss.sgi.com

On 8/27/13 7:16 AM, chandan wrote:
> On Monday, August 26, 2013 09:29:31 AM Eric Sandeen wrote:
>>
>> Just as a sanity check, does it also fail on xfs for 64k block sizes on ppc64?
>>
> 
> Yes, it does fail as shown below:
> 

(removing linux-btrfs for now):

Hohum, I get failures on 2k and even 4k blocksize xfs (and ext4) on ppc64 as well.
(this was on a 3.10 kernel)

Have you seen this?

I guess I'm a little reluctant to restrict the test to <=4k until we understand
what all the issues are and at least see it passing on the smaller block
sizes... do they work for you?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
