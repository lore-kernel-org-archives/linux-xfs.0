Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C92C27CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 06:20:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 495F8AC001
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 04:20:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XMUnl0Lot7QP4Mhs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 04:20:35 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 0F0378F4E2
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:20:34 +0000 (UTC)
Received: from redhat.com (vpn-61-170.rdu2.redhat.com [10.10.61.170])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2LBKVbe011365
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 07:20:33 -0400
Date: Mon, 21 Mar 2016 12:20:30 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: obtaining xfstests repository
Message-ID: <20160321112030.GA25476@redhat.com>
References: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
	<20160321063848.GK11812@dastard>
	<CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
	<20160321073016.GR30721@dastard>
	<CANq6e6jPz5fDeCCQuZFEYmApCFH0-pkBYJ-Z-s7zYap3QM3sEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANq6e6jPz5fDeCCQuZFEYmApCFH0-pkBYJ-Z-s7zYap3QM3sEQ@mail.gmail.com>
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
To: xfs@oss.sgi.com

As Dave suggested, try cloning over http, your work firewall might be blocking
different protocols.

$git clone https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

On Mon, Mar 21, 2016 at 08:39:37AM +0100, Sonia mandelbrott wrote:
>    It is probably because I am using my work connection...
>    But thank you for all the replies :)
> 
>    On Mon, Mar 21, 2016 at 8:30 AM, Dave Chinner <[1]david@fromorbit.com>
>    wrote:
> 
>      On Mon, Mar 21, 2016 at 08:22:09AM +0100, Sonia mandelbrott wrote:
>      > Thank you for your replies, here is output when used your link:
>      >
>      > -bash-4.2$ git clone
>      git://[2]git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
>      > Cloning into 'xfstests-dev'...
>      > fatal: unable to connect to [3]git.kernel.org:
>      > [4]git.kernel.org[0: 149.20.4.72]: errno=Connection timed out
>      > [5]git.kernel.org[1: 199.204.44.194]: errno=Connection timed out
>      > [6]git.kernel.org[2: 198.145.20.140]: errno=Connection timed out
>      > [7]git.kernel.org[3: 2620:3:c000:a:0:1991:8:25]: errno=Network is
>      unreachable
>      > [8]git.kernel.org[4: 2001:4f8:1:10:0:1991:8:25]: errno=Network is
>      unreachable
>      There's almost certainly a firewall in your way. Try cloning over
>      http.
> 
>    Cheers,
>    Dave.
>    --
>    Dave Chinner
>    [9]david@fromorbit.com
> 
> References
> 
>    1. mailto:david@fromorbit.com
>    2. http://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
>    3. http://git.kernel.org/
>    4. http://git.kernel.org/
>    5. http://git.kernel.org/
>    6. http://git.kernel.org/
>    7. http://git.kernel.org/
>    8. http://git.kernel.org/
>    9. mailto:david@fromorbit.com

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
