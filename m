Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32C5E7CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 02:30:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99A3DAC001
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:30:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	W1RCGU7StNBCiyIW for <xfs@oss.sgi.com>;
	Mon, 21 Mar 2016 00:30:30 -0700 (PDT)
Date: Mon, 21 Mar 2016 18:30:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: obtaining xfstests repository
Message-ID: <20160321073016.GR30721@dastard>
References: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
	<20160321063848.GK11812@dastard>
	<CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
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
To: Sonia mandelbrott <sonia.mandelbrott@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 21, 2016 at 08:22:09AM +0100, Sonia mandelbrott wrote:
> Thank you for your replies, here is output when used your link:
> 
> -bash-4.2$ git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> Cloning into 'xfstests-dev'...
> fatal: unable to connect to git.kernel.org:
> git.kernel.org[0: 149.20.4.72]: errno=Connection timed out
> git.kernel.org[1: 199.204.44.194]: errno=Connection timed out
> git.kernel.org[2: 198.145.20.140]: errno=Connection timed out
> git.kernel.org[3: 2620:3:c000:a:0:1991:8:25]: errno=Network is unreachable
> git.kernel.org[4: 2001:4f8:1:10:0:1991:8:25]: errno=Network is unreachable

There's almost certainly a firewall in your way. Try cloning over
http.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
