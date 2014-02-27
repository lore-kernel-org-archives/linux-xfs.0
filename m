Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8CE177F4E
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:19:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 322EEAC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 13:19:18 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id KG7k3M2UJh8EPOAu
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 13:19:16 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: XFS on Fedora i686, armv7hl
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140227072122.GL29907@dastard>
Date: Thu, 27 Feb 2014 14:19:12 -0700
Message-Id: <E67AB61C-9A3C-49AF-A9DC-4576F1CB5449@colorremedies.com>
References: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
	<20140227072122.GL29907@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Feb 27, 2014, at 12:21 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Feb 26, 2014 at 10:37:59PM -0700, Chris Murphy wrote:
> =

>> Btrfs volume mounts OK, although I don't know if it actually
>> withstands significant use.
>> http://paste.fedoraproject.org/80784/93470280/
> =

> I bet that's because nobody has filled a btrfs filesystem past the
> point where it tries to access beyond 16TB on a 32 bit system and so
> it's never been reported as a bug=85 :/

Guess what? Someone just ran into what sounded like this very problem today=
 on the Btrfs list [1]. So I reported it and referenced this thread, and it=
 looks like you were correct. Josef is on it [2].


Chris Murphy

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31856.html
[2] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31862.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
