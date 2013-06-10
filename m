Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B25657F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 08:44:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C83F304062
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 06:44:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6WKuiZMYTqUCyK6Y for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 06:44:03 -0700 (PDT)
Message-ID: <51B5D824.3060704@sandeen.net>
Date: Mon, 10 Jun 2013 08:44:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: attack upon XFS, misinformation abounds, linux-raid list
References: <51B45CFD.20500@hardwarefreak.com>
	<CAAxjCEznq0RDnnYR_mQ=gmSeson4acyiLVcVdOh2vmQo1cVAzA@mail.gmail.com>
In-Reply-To: <CAAxjCEznq0RDnnYR_mQ=gmSeson4acyiLVcVdOh2vmQo1cVAzA@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 6/10/13 4:43 AM, Stefan Ring wrote:
> On Sun, Jun 9, 2013 at 12:46 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> In a recent linux-raid list thread here:
>> http://marc.info/?l=linux-raid&m=137072140106867&w=2
>>
>> seriously flawed arguments against the reliability of XFS, and even the
>> performance of XFS, are made.  The OP even quotes Dave's LCA
>> presentation as a performance reason to avoid XFS.  The party really
>> gets started at paragraph 7.
>>
>> I made a brief effort to debunk his claims and explained that he can't
>> have O_PONIES, that he should use fsync or O_DIRECT, etc for data
>> safety.  To non experts/advanced filesystem users, his long winded
>> argument may be persuasive.  Obviously none of you experts has time to
>> debunk every such post, but this one may be worth a read at least,
>> especially given the weight Google gives to vger lists.
> 
> The really unfortunate thing about this is that the bug[1] which would
> prevent transaction flushing from happening got imported and shipped
> for a rather long time in RHEL. It's one thing to get a file zeroed
> that's a few seconds old, but having the same happen to files which
> haven't been touched in hours, even before issuing manual sync, is
> certainly not very reassuring.

Bugs and regressions are always unfortunate, and this one was no exception.
It was pretty obscure, but we (mostly Dave) worked with our customers
to identify & resolve it within days of the bug report.

As far as I know, the bug existed only for a crash, not a reboot.

> As a very satisfied user of XFS on CentOS 6, I have been nervous
> enough about that to go through the trouble of rebooting our main
> server for a kernel upgrade a few weeks ago. Thanks to RedHat's
> deceptive tactics regarding kernel patches, I have also not been able

deceptive - adj. - Giving an appearance or impression different from the true one; misleading.

which sounds pretty damning.  Perhaps more accurate is:

obfuscated - adj. - Rendered obscure, unclear, or unintelligible ;)

> to pin-point the exact range of kernel versions affected by this in a
> reasonable amount of time and hence have not found out (thankfully not
> the hard way) if it was even necessary.

It was introduced in 6.2 and resolved in 6.4, as well as 6.2
and 6.3 z-stream kernels.  Those are the sorts of things Red Hat support
can help customers identify more quickly & clearly.

-Eric

> [1] https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/6.4_Technical_Notes/kernel.html
> "BZ#855139"
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
