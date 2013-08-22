Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 453A07FB6
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 04:16:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D56B7AC001
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 02:16:20 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	pBnS0drPCK7nQOjZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 02:16:19 -0700 (PDT)
Received: by mail-wi0-f172.google.com with SMTP id hj13so381873wib.11
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 02:16:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21672216.3390.1376260599697.JavaMail.root@benjamin.baylink.com>
References: <29874428.3384.1376259762936.JavaMail.root@benjamin.baylink.com>
	<21672216.3390.1376260599697.JavaMail.root@benjamin.baylink.com>
Date: Thu, 22 Aug 2013 11:16:18 +0200
Message-ID: <CAAxjCEz42u8rUZfDtw==-Eo0LoTx_u4Ex2_qJZH-r5P14G159w@mail.gmail.com>
Subject: Re: XFS recovery resumes...
From: Stefan Ring <stefanrin@gmail.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Mon, Aug 12, 2013 at 12:36 AM, Jay Ashworth <jra@baylink.com> wrote:
> (and I apologize that I can't copy that in; I was running under screen, and
> it doesn't cooperate with scrollback well).

Running inside screen is perfect for conserving scrollback, although
actually getting it out is a bit tedious:

- Enter copy mode: Ctrl-a Ctrl-[ (moving around: Pg-Up/Pg-Down via
Ctrl-B/Ctrl-F)
- Mark a selection: SPC + moving up or down
- Yank: Y
- Write to file: Ctrl-a :writebuf /tmp/scrlog

I also tend to have this in my ~/.screenrc:

defscrollback 20000

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
