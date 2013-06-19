Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2539C7CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 09:54:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1617AC004
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 07:54:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G3SoLGHqNPj25OSj for
	<xfs@oss.sgi.com>; Wed, 19 Jun 2013 07:54:27 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5JEsRG3024873
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 10:54:27 -0400
Received: from dhcp-186-20.bos.redhat.com (dhcp-185-29.bos.redhat.com
	[10.16.185.29])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r5JEsQJj006128
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 10:54:26 -0400
Message-ID: <51C1C622.7050704@redhat.com>
Date: Wed, 19 Jun 2013 10:54:26 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619143537.GN20932@sgi.com>
	<20130619144441.GA14834@infradead.org>
In-Reply-To: <20130619144441.GA14834@infradead.org>
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
To: xfs@oss.sgi.com

On 06/19/2013 10:44 AM, Christoph Hellwig wrote:
> On Wed, Jun 19, 2013 at 09:35:37AM -0500, Ben Myers wrote:
>> >Dave,
>> >
>> >On Wed, Jun 19, 2013 at 02:50:08PM +1000, Dave Chinner wrote:
>>> > >This is my patch queue for 3.11 as it stands right now.
>> >
>> >Getting all of this in for 3.11 does not strike me as being realistic.  You
>> >need to think about how this can be split up.  I see that you have rebased
>> >Jeff's log size validation patch set after your rearrangement.  I'd rather
>> >you'd taken Jeff's series first and then made your changes.  Now we can't pull
>> >in Jeff's work without pulling in a bunch of rearrangement that hasn't been
>> >fully discussed.  You have also crowded out Chandra's quota work.  We had an
>> >agreement with him to go for 3.11 with that work which you have broken.
> I think 3.11 is a realistic target for all the code movearound, but
> maybe not as part of the normal pull request for -rc1.  If we make sure
> it's really moving code around and not changing it I think a sending a
> second pull request to Linus saying this is just code movearounds we
> wanted to do when the churn causes least problems with actual code work
> he should be fine with it.

Just to chime in here, we have a lot of resources focused on testing these XFS 
updates both internally with our QA team and with a range of other RH partners.

I am confident we can shake out any integration concerns in time.

Thanks!

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
