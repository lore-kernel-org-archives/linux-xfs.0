Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 16:23:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3RNMnuH003939
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:22:51 -0700
Date: Mon, 28 Apr 2008 09:23:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080427232317.GB103491721@sgi.com>
References: <200804270246.58828.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804270246.58828.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 02:46:58AM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> This patch reduces xfs_page_state_convert() stack usage by 16 bytes
> by eliminating some local variables, and reducing the size
> of scope for other locals.
> 
> Compile tested only.

Can you start testing your patches? if you are touching the writeback
or allocator path, there's a pretty high barrier to having patches
excepted, and testing them before is one of them. Go and download the
XFSQA suite from the xfs-cmds CVS tree on oss.sgi.com, and run your
patches through it....

> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> P.S.
> 
> xfs_page_state_convert() carries the following comment:
>  * Calling this without startio set means we are being asked to make a dirty
>  * page ready for freeing it's buffers.  When called with startio set then
>  * we are coming from writepage.
> which leads to the following proposal: reimplement it as two
> functions, one which work as if startio parameter == 0
> and the other as if startio == 1.
> This will result in a bit of code duplication, but reduces
> stack usage on writepage path and allows for these two functions
> to have more descriptive names. (Presently the meaning of this
> function needs to be explained in that comment -> function
> name is not descriptive enough, because it does different things
> depending on startio value).
> 
> Do you like this idea?

No. That code is complex enough with only one copy of it around. I don't
want two copies that differ subtly and hence have two different sets
of nasty, rarely hit corner cases in them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
