Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72D1A7F5A
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:56:58 -0500 (CDT)
Received: from dhcp-128-162-232-117.americas.sgi.com
	(dhcp-128-162-232-117.americas.sgi.com [128.162.232.117])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4185A8F8065
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:56:58 -0700 (PDT)
Message-ID: <53E93C29.1020103@sgi.com>
Date: Mon, 11 Aug 2014 16:56:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Subject : Happened again,
	20140811 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
In-Reply-To: <alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
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
To: xfs@oss.sgi.com

On 08/11/14 16:50, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
>
>
> El 2014-08-11 a las 16:27 -0500, Mark Tinguely escribi=F3:
>> On 08/11/14 10:34, Carlos E. R. wrote:
>
>>
>> so XFS gave a forced shutdown after the machine came back from
>> hibernation. After replaying the log, there were no errors in xfs_repair.
>>
>> We should have quiesced the metadata/log before freezing xfs. Was
>> there a lot of items in the log?
>
> Sorry, what log? The /var/log/messages file? I posted it in full, from
> before the hibernation to powerdown.
>
> - -- Cheers
> Carlos E. R.

Sorry, I was referring to the XFS log.

If you had a metadata dump before mounting/xfs_repair, then you can =

display the xfs log using the xfs_logprint.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
