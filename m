Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 739607CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 02:30:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5411F30404E
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 00:30:35 -0700 (PDT)
Received: from emea01-am1-obe.outbound.protection.outlook.com
	(mail-am1lp0014.outbound.protection.outlook.com
	[213.199.154.14]) by cuda.sgi.com with ESMTP id
	5C1Ns3BgHwubY0BA (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 00:30:33 -0700 (PDT)
Message-ID: <519F1708.10603@zynstra.com>
Date: Fri, 24 May 2013 08:30:16 +0100
From: James Dingwall <james.dingwall@zynstra.com>
MIME-Version: 1.0
Subject: Re: Cleancache support in XFS
References: <51810CED.4080003@zynstra.com> <20130501162044.GN29359@sgi.com>
	<20130501223022.GQ10481@dastard> <518222D3.3080109@zynstra.com>
	<20130522192834.GD10617@phenom.dumpdata.com>
In-Reply-To: <20130522192834.GD10617@phenom.dumpdata.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

Konrad Rzeszutek Wilk wrote:
> On Thu, May 02, 2013 at 09:24:51AM +0100, James Dingwall wrote:
>> Dave Chinner wrote:
>>> On Wed, May 01, 2013 at 11:20:44AM -0500, Ben Myers wrote:
>>>> Hi James,
> Hey folks,
> I am walking through my vacation-emails-mbox.
>
>>>> On Wed, May 01, 2013 at 01:39:09PM +0100, James Dingwall wrote:
>>>>> In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html
>>>>>
>>>>> $ grep -r cleancache fs/xfs
>>>>> on the 3.9 kernel source suggests that no patch was submitted to
>>>>> enable cleancache for the XFS filesystem.  Since it was suggested
>>>>> that this could be a one liner I've had a go and my first effort is
>>>>> inline below.  While this seems to compile OK I have no experience
>>>>> in filesystems so I would appreciate it if anyone can point out that
>>>>> it is obviously wrong and likely to eat my data before I try booting
>>>>> the kernel.
>>>>>
>>>>> If it seems a reasonable attempt what would be the best way to check
>>>>> that it isn't doing nasty things?
>>>> Hrm.. Looks like there is a doc in Documentation/vm/cleancache.txt which
>>>> includes a list of attributes the filesystem needs to have to work properly
>>>> with cleancache.
>>> So, those points are:
>> I had started to look at these too but I feel very out of my depth!
>> I had similar conclusions to what Dave wrote but I don't think my
>> thoughts should carry very much (any) weight.  Anyway I gambled and
>> booted my xen domU with this patch and so far so good...  xen top
>> shows that tmem is now being used where previously it wasn't.  I'll
>> try running the xfstests at the weekend after a couple more days up
>> time to see what happens.
> And how did it go?
I am running the patch I created on 3.9.3 on half of my xen guests now 
and have not noticed any stability or filesystem problems.  xl top with 
'T' shows that the guests running with it are using ephemeral pages were 
those without do not.  I did do some runs with xfstests which had some 
failures but they were present with and without the patch.  The best I 
can really offer is that it works for me, ymmv.  The patch is available 
as commit c725011c4fc5d47e12d131f61bd91a58a40036b5 in 
https://github.com/JKDingwall/linux.git xfs-enable-cleancache or in the 
first message of this thread.

Regards,
James

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
