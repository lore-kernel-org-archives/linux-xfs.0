Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73B7F7F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 17:35:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B638304066
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:35:25 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	K1BpnX3zEYdBYDqH for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 15:35:23 -0800 (PST)
Date: Tue, 25 Feb 2014 10:35:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add function _require_fssum()
Message-ID: <20140224233520.GT13647@dastard>
References: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
	<20140224122310.GO4317@dastard>
	<CAL3q7H5tfnb+uqa-ru5YNcok1n8PQxxai7UfkH-YgCdts84Tew@mail.gmail.com>
	<20140224222216.GP4317@dastard>
	<CAL3q7H7N3VVrfoVvNx_4wPsP38FO=sLNCBC-VJ2Tsz4NLqh39A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL3q7H7N3VVrfoVvNx_4wPsP38FO=sLNCBC-VJ2Tsz4NLqh39A@mail.gmail.com>
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
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Feb 24, 2014 at 11:08:27PM +0000, Filipe David Manana wrote:
> On Mon, Feb 24, 2014 at 10:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Feb 24, 2014 at 01:22:36PM +0000, Filipe David Manana wrote:
> >> On Mon, Feb 24, 2014 at 12:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> >> diff --git a/tests/btrfs/007 b/tests/btrfs/007
> >> >> index 5df9ccb..5430613 100755
> >> >> --- a/tests/btrfs/007
> >> >> +++ b/tests/btrfs/007
> >> >> @@ -31,7 +31,6 @@ seq=`basename $0`
> >> >>  seqres=$RESULT_DIR/$seq
> >> >>  echo "QA output created by $seq"
> >> >>
> >> >> -here=`pwd`
> >> >>  tmp=`mktemp -d`
> >> >>  status=1
> >> >
> >> > Yeah, redefining $here is a bad thing to do :/
> >
> > Right, my mistake. It needs to be defined for the entire test, not
> > in a requires function. Hence I think we should just export it from
> > check....
> 
> Hum, ok. So the decision is to let the tests explicitly define the
> variable "here", and not export "here" from the main check script.

Well, that's the status quo right now.

What I'm suggesting is that we should just export it from check and
get rid of it from each test as a separate cleanup. i.e. It always
needs to be set to the same value (i.e. the root of the xfstests
tree) so there is no reason why it should not be set up once in a
central location.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
