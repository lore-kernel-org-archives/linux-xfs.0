Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0BB57F3F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 21:58:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 809C3304048
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 19:58:07 -0700 (PDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
	[209.85.215.45]) by cuda.sgi.com with ESMTP id BMFYhsAfoTX02gV2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Oct 2014 19:58:02 -0700 (PDT)
Received: by mail-la0-f45.google.com with SMTP id q1so7569290lam.4
	for <xfs@oss.sgi.com>; Tue, 07 Oct 2014 19:58:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412197494-7655-1-git-send-email-hch@lst.de>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
Date: Tue, 7 Oct 2014 22:58:01 -0400
Message-ID: <CANP1eJHc+OeicA1i2-Ct2q+Tj6bBYivBinJX8X=W4xyMwG3hdg@mail.gmail.com>
Subject: Re: preadv2/pwritev2 updates
From: Milosz Tanski <milosz@adfin.com>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

I'm haven't gotten to many comments back from the last set of patches.
So I imagine that people are okay with the interface and the general
code.

The next submission will probably rename the call to preadv6/pwritev6
just to follow the interface ... but I don't think they'll be any
other changes; so no need to wait on me. How should we go about
packaging this up for mainline inclusion?

Additionally, I've been testing it with out application in and in the
test environment we've a 30% reduction in average response time. We
might be kind of a best case since we do a fair amount of CPU / IO
bound work overlapped and this lets us skip the threadpool queue in a
huge chunk of the cases. But the gains are real... for a real
application.

On Wed, Oct 1, 2014 at 5:04 PM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Miklos,
>
> attached are the patches that go on top of your
> "[RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache only)"
> series.  The first one adds RWF_NONBLOCK to XFS, the other two
> add a new RWF_DSYNC flag that adds a per-operation O_DSYNC flag.
>



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
