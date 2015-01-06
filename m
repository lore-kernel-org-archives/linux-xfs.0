Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D2F37FB7
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 13:42:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0AFBAC007
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:42:41 -0800 (PST)
Received: from mail-yh0-f51.google.com (mail-yh0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id gU8A8QoNyVawaEm7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2015 11:42:39 -0800 (PST)
Received: by mail-yh0-f51.google.com with SMTP id a41so11757777yho.24
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 11:42:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54AC363E.1090109@sandeen.net>
References: <1806495.BCZcrVVEOf@shtub-cm> <54AC1511.1060908@sandeen.net>
	<CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>
	<54AC363E.1090109@sandeen.net>
Date: Tue, 6 Jan 2015 12:42:38 -0700
Message-ID: <CAJCQCtRUq9ozu74TBjm4G-yoC0kQa7Vr8nUTNzke6O7DTWQPXw@mail.gmail.com>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
From: Chris Murphy <lists@colorremedies.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jan 6, 2015 at 12:23 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 1/6/15 1:05 PM, Chris Murphy wrote:
>> On Tue, Jan 6, 2015 at 10:02 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> however, some drives lie about these sizes, and then mkfs.xfs can't know.
>>> Try the blockdev command above to see.
>>
>> blockdev and parted seem to get this wrong for a device for which
>> smartctl and hdparm get correct
>
> I don't think they get it wrong, they are just reporting what the
> drive says over that interface.

The problem may be that the drive isn't being queried, but rather the
bridge chipset involved. All drives are AF drives in USB 3 enclosures.
But somehow hdparm and smartctl are getting actual drive info from the
drive through this interface; while the kernel appears to be fooled by
bridge.

I don't immediately have a way to directly connect any to SATA. I will
bet dollars to donuts this is what's going on though, because I know
one of these drives when it was connected via SATA was reported by
parted as 512B/4096B but currently it isn't.

-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
