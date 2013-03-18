Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 167657F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 17:51:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2A6A8F8040
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:51:07 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id NLt93IAw63AIQiP2 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 15:51:06 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.136364690024530@bugs.debian.org>
Date: Tue, 19 Mar 2013 09:48:14 +1100
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20130318224814.GP6369@dastard>
References: <CAA0ZO6CtLRkgrpXqapg3B5oMwGdLq8tS3y4dYG47aYX5BZkA=g@mail.gmail.com>
	<20121211221419.GZ27055@sgi.com>
	<CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
	<CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
Reply-To: Dave Chinner <david@fromorbit.com>, 695640@bugs.debian.org
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
To: Brian May <brian@microcomaustralia.com.au>
Cc: 695640@bugs.debian.org, Ben Myers <bpm@sgi.com>

On Mon, Mar 18, 2013 at 11:30:35AM +1100, Brian May wrote:
> On 12 December 2012 10:20, Brian May <brian@microcomaustralia.com.au> wrote:
> 
> > On 12 December 2012 10:15, Dave Chinner <david@fromorbit.com> wrote:
> >
> >> Full strace output, please.
> >
> >
> > Attached.
> >
> 
> Did my strace output help diagnose this bug?

No, but it's most likely the same problem as fixed in commit
19473a2ac. Can you add this to quota/quot.c:quot_init():

+	quot_cmd.flags = CMD_FLAG_GLOBAL;

And see if the problem goes away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
