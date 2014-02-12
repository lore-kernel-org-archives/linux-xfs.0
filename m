Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DAB67F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 14:13:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9326EAC007
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 12:13:21 -0800 (PST)
Received: from mail-ve0-f174.google.com (mail-ve0-f174.google.com
	[209.85.128.174]) by cuda.sgi.com with ESMTP id
	OtDt6hDplwCuMysT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 12:13:20 -0800 (PST)
Received: by mail-ve0-f174.google.com with SMTP id pa12so7615060veb.5
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 12:13:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140212113928.GO18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
Date: Wed, 12 Feb 2014 12:13:19 -0800
Message-ID: <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Feb 12, 2014 at 3:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 11, 2014 at 10:28:12PM -0800, Linus Torvalds wrote:
>
>> It looks like just "do_signal()" has a stack frame that is about 230
>> bytes even under normal circumstancs (largely due to "struct ksignal"
>> - which in turn is largely due to the insane 128-byte padding in
>> siginfo_t). Add a few other frames in there, and I guess that if it
>> was close before, the coredump path just makes it go off.
>
> We could, in principle, put it into task_struct and make get_signal()
> return its address - do_signal() is called only in the code that does
> assorted returns to userland...

We have better uses for random buffers in "struct task_struct", I'd
hate to put a siginfo_t there.

The thing is, siginfo_t has that idiotic 128-byte area, but it's all
"for future expansion". I think it's some damn glibc disease - we've
seen these kinds of insane paddings before.

The actual *useful* part of siginfo_t is on the order of 32 bytes. If that.

Sad.

                Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
