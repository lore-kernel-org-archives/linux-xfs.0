Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27C127F8B
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 17:34:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B799FAC004
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:34:23 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YEONEVot9pWZo3PK for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 15:34:21 -0800 (PST)
Date: Wed, 12 Nov 2014 10:34:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enforcing quota for root user
Message-ID: <20141111233419.GX28565@dastard>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
	<54622CE8.7050508@hardwarefreak.com>
	<631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
	<20141111223203.GS28565@dastard> <54628F7B.7080604@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54628F7B.7080604@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Tue, Nov 11, 2014 at 04:36:43PM -0600, Eric Sandeen wrote:
> On 11/11/14 4:32 PM, Dave Chinner wrote:
> > On Tue, Nov 11, 2014 at 11:00:25AM -0700, Chris Murphy wrote:
> >>
> >> On Nov 11, 2014, at 8:36 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> >>
> >>> On 11/11/2014 04:22 AM, Cyril Scetbon wrote:
> >>>> That's what I've read first, but someone showed me a sample where it works. He just told me he was using project quota. However, does it make sense ? 
> >>>> I've also read somewhere else that quota is never enforced for root user (id,gid=0) that's why I was testing it ....
> >>>
> >>> No, it doesn't make sense.  Why would you want to enforce quotas for root?
> >>
> >> A week ago I tried this and project quotas appear to apply to root.
> > 
> > By intent and design. Project quotas are not a user/group based
> > quota and so there is no exemption for any user.
> 
> However, at least according to the manpage, "project ID 0" is not
> enforced.  Granted, that is not a *user* exception.

Correct, and again by intent and design as project quotas are
optional.  i.e. there has to be some way of ensuring non-project ID
controlled files won't have quota enforcement applied to them. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
