Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9MABHVu164051 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 05:11:18 -0500
Received: from smtprelay04.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53A78F4D562
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 03:27:41 -0700 (PDT)
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de
	[80.67.31.42]) by cuda.sgi.com with ESMTP id JMW8LDUKEqAoNJ65
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 03:27:41 -0700 (PDT)
Message-ID: <4CC1638B.4070807@cape-horn-eng.com>
Date: Fri, 22 Oct 2010 12:12:27 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: cannot defrag volume, fragmentation factor 21.73%
References: <4CBC3910.70806@cape-horn-eng.com> <20101018231009.GL29677@dastard>
In-Reply-To: <20101018231009.GL29677@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/19/2010 01:10 AM, Dave Chinner wrote:
> Understand your numbers. What frag reports is how many extents there
> are vs a perfect layout. It does not tell you how badly fragmented
> your filesystem is. Extent-based filesystems can have
> "fragmentation" like you see reported above, but not suffer at all
> because the extents are large enough not to affect IO throughput.

Hi Dave,

I think I almost got that now.
But, at which numbers should I look at before starting a defrag then?

Up to now, I ran always "echo frag | xfs_db -r /dev/..." to get a =

"number" that could tell me if starting a xfs_fsr was necessary.

At which other numbers should I look at to see if running a xfs_fsr =

defrag is necessary or not?

Many thanks,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
