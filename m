Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n92Gthmt192328 for <xfs@oss.sgi.com>; Fri, 2 Oct 2009 11:55:44 -0500
Received: from cdptpa-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42FC111966BC
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2009 09:57:05 -0700 (PDT)
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.121]) by cuda.sgi.com with ESMTP id
	aTayhVeiCHHOdyuU for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2009 09:57:05 -0700 (PDT)
Date: Fri, 2 Oct 2009 11:57:04 -0500
From: David Engel <david@istwok.net>
Subject: Re: XFS/driver bug or bad drive?
Message-ID: <20091002165704.GA17558@opus.istwok.net>
References: <20091001232759.GA12832@opus.istwok.net>
	<4AC54BDA.20806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AC54BDA.20806@sandeen.net>
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
To: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Thu, Oct 01, 2009 at 07:39:54PM -0500, Eric Sandeen wrote:
> These are all storage errors, not xfs.  I suppose it could be
> differing IO patterns from one fs or the other that trips it up, but
> nothing above is related to an xfs bug; any xfs problems are in
> response to the above IO errors, maybe a hardware problem or a
> driver problem, not sure - but most likely a hardware issue I think.
> You might point smartctl at the drive and see what it says.

I agree it shouldn't be an xfs bug.  I thought it was strange, though,
that the problem only seemed to show up with xfs on 2.6.30.x.  IO
pattern sensitivity wouldn't surprise me, but I wanted to check all my
bases before giving up on the drive.

Michael Monnerie wrote:
> Yes, that Samsung crap. Of the very few drives we had (the 1TB version), 
> all got broken quickly, and we replaced them with Hitachis. It's a pity, 
> as they had a nice price, but when they it your data, it's priceless.

I've used mostly Samsung drives for several years.  This particular
750GB model is the only one that I consider a lemon.

David
-- 
David Engel
david@istwok.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
