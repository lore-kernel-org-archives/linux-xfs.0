Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 86F7C7CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 19:00:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E897AAC006
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 16:59:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VwkBWCKtHqyvRaXt for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 16:59:54 -0700 (PDT)
Date: Wed, 28 Aug 2013 09:59:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS recovery resumes...
Message-ID: <20130827235949.GA6023@dastard>
References: <29874428.3384.1376259762936.JavaMail.root@benjamin.baylink.com>
	<21672216.3390.1376260599697.JavaMail.root@benjamin.baylink.com>
	<CAAxjCEz42u8rUZfDtw==-Eo0LoTx_u4Ex2_qJZH-r5P14G159w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEz42u8rUZfDtw==-Eo0LoTx_u4Ex2_qJZH-r5P14G159w@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Jay Ashworth <jra@baylink.com>, Linux fs XFS <xfs@oss.sgi.com>

On Thu, Aug 22, 2013 at 11:16:18AM +0200, Stefan Ring wrote:
> On Mon, Aug 12, 2013 at 12:36 AM, Jay Ashworth <jra@baylink.com> wrote:
> > (and I apologize that I can't copy that in; I was running under screen, and
> > it doesn't cooperate with scrollback well).
> 
> Running inside screen is perfect for conserving scrollback, although
> actually getting it out is a bit tedious:
> 
> - Enter copy mode: Ctrl-a Ctrl-[ (moving around: Pg-Up/Pg-Down via
> Ctrl-B/Ctrl-F)
> - Mark a selection: SPC + moving up or down
> - Yank: Y
> - Write to file: Ctrl-a :writebuf /tmp/scrlog
> 
> I also tend to have this in my ~/.screenrc:
> 
> defscrollback 20000

Add this to your ~/.screenrc:

termcapinfo xterm|xterms|xs|rxvt ti@:te@

And screen will write to the terminal's scrollback buffer rather
than it's own internal buffer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
