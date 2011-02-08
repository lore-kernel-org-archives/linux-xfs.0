Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p181Wwvw081848 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 19:32:59 -0600
Subject: Re: mkfs.xfs pagefault when removed storage during operation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <AANLkTi=7dw1-r8BSdv7y51LzmWekxKjLrCv_Rky7EYx9@mail.gmail.com>
References: <AANLkTi=wi_Fhr5v1J4wopvFTY=hC2EA_QmJu4Uc_XgGs@mail.gmail.com>
	<AANLkTi=7dw1-r8BSdv7y51LzmWekxKjLrCv_Rky7EYx9@mail.gmail.com>
Date: Mon, 07 Feb 2011 19:35:31 -0600
Message-ID: <1297128931.2078.32.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-02-02 at 17:09 +0900, Ajeet Yadav wrote:
> If I see the current sigfault, its easy to fix adding one more patch
> to xfsprogs.
. . .
> 
> But when I start reviewing the complete project w.r.t read() /
> read64() / write() / write64() more importantly libxfs_readbufr() /
> libxfs_writebufr().
> I find error handing is broken at may places and I get my self lost in
> m^n complexity also errno is lost.. therefore caller cannot examine
> the exact error,
> 
> Back again I think, What if I exit on error ? Does xfsprogs uses
> read() / write() error as a part of its functionality, for example
> does xfs_repair uses these errors as a part of repair funtionality.
. . .

I think these are good observations and questions.

This doesn't answer your questions, but I want to mention to
you that libxfs is just about to have a major update that
affects lots of files.  I expect the update will *not*
address the issues you point out here, but I guess what I'd
like to do is get us moved to the updated code before trying
to address problems that might be widespread like this.

I hope to complete this update process soon, but I expect
it will be a week or more before that happens.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
