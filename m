Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1A5F7F9E
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 20:21:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 679B4AC001
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 18:21:30 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 161TI5deweuLwXxt
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 18:21:29 -0800 (PST)
Message-ID: <530809A7.70900@hardwarefreak.com>
Date: Fri, 21 Feb 2014 20:21:27 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net>
	<52EB3B96.7000103@hardwarefreak.com>	<1391202273-sup-9265@al.wesleyan.edu>	<52ED61C9.8060504@hardwarefreak.com>	<20140202212152.GP2212@dastard>	<1391443675-sup-1730@al.wesleyan.edu>	<20140203214128.GR13997@dastard>	<52F09E36.8050606@hardwarefreak.com>	<1392748390-sup-1943@al.wesleyan.edu>	<5303E7AC.50903@hardwarefreak.com>	<20140220183125.29149.64880@al.wesleyan.edu>	<5306C90B.1000904@hardwarefreak.com>
	<20140221095742.0ca161b0@galadriel.home>
In-Reply-To: <20140221095742.0ca161b0@galadriel.home>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs@oss.sgi.com

On 2/21/2014 2:57 AM, Emmanuel Florac wrote:
> Le Thu, 20 Feb 2014 21:33:31 -0600 vous =E9criviez:
> =

>> Forget all of this.  Forget RAID60.  I think you'd be best served by a
>> concatenation.
> =

> I fully  agree, though I'd use... LVM to perform the concatenation,
> much more convenient and easy to use than md IMO.

Using md linear eliminates the LVM physical extent size non power of 2
misalignment issue we discussed at length up thread.  Using LVM makes
things decidedly more difficult and for zero gain.  LVM just isn't
appropriate for Morgan's situation.

Now, it's possible he could do this entirely in the RAID firmware.
However he has not stated which storage product he has, and thus I don't
know its capabilities, whether it can create or seamlessly expand a
concatenation.  Linux md can do all of this very easily and is deployed
by many people in this exact scenario.

-- =

Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
