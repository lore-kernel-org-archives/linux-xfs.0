Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RHFs0o213860 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 12:15:54 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21714182E90C
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 10:15:53 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id wZx9bBJlX4M4hL9S for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 10:15:53 -0700 (PDT)
Date: Wed, 27 Jul 2011 13:15:53 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <4E303F6F.8010706@netapp.com>
Message-ID: <alpine.DEB.2.02.1107271315290.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<4E303F6F.8010706@netapp.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Wed, 27 Jul 2011, Bryan Schumaker wrote:

> On 07/27/2011 12:28 PM, Justin Piszcz wrote:
>>
>>
>> On Wed, 27 Jul 2011, J. Bruce Fields wrote:
>>
>>> On Wed, Jul 27, 2011 at 09:54:09AM -0400, Justin Piszcz wrote:
>>>> Hi,
>>>>
>>>> Kernel 2.6.30 on client.
>>>> Kernel 2.6.28 on server.
>>>>
>>>> p34 kernel: [92223.918892] NFS: directory motion/cam2 contains a
>>>> readdir loop.  Please contact your server vendor.  Offending cookie: 10272
>>>
>>> What filesystem on the server are you exporting?
>>
>> Hi,
>>
>> xfs.
>> /dev/sda1 on / type xfs (rw,noatime)
>>
>> Nothing special, thoughts?
>
> Are there a lot of files in the directory you're exporting?  It looks like cookie 10272 is mapped to multiple files. When the client tries to resume reading from this cookie, xfs will reply from the first matching file and cause the client to enter a loop.

Should I be using a different filesystem?

user@atom:/d1$ cd /d1/motion/cam1
user@atom:/d1/motion/cam1$ ls|wc
    5198    5198  140346
user@atom:/d1/motion/cam1$

Justin.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
