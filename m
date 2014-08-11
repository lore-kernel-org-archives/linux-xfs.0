Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F51F7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:27:16 -0500 (CDT)
Message-ID: <53E93530.4070902@sgi.com>
Date: Mon, 11 Aug 2014 16:27:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Subject : Happened again,
	20140811 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
In-Reply-To: <alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On 08/11/14 10:34, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
>
>
> El 2014-08-11 a las 09:57 -0500, Mark Tinguely escribi=F3:
>> On 08/11/14 09:23, Carlos E. R. wrote:
>
>> Where in the filesystem did the XFS_WANT_CORRUPTED_GOTO happen?
>
> This time?
> Did not look at the log yet. Let me see...
>
> Here is the full log of the event. It starts prior to hibernating, all
> things nominal. And ends on shutdown (had to hit reset button, despite
> what log says). If you want to see entries prior to that, since boot, I
> can do that.
>

...

so XFS gave a forced shutdown after the machine came back from =

hibernation. After replaying the log, there were no errors in xfs_repair.

We should have quiesced the metadata/log before freezing xfs. Was there =

a lot of items in the log?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
