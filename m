Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7E237F67
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 13:23:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5053304048
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:23:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SAjHxbTzXPnxZdCX for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 11:23:44 -0800 (PST)
Message-ID: <54AC363E.1090109@sandeen.net>
Date: Tue, 06 Jan 2015 13:23:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
References: <1806495.BCZcrVVEOf@shtub-cm>	<54AC1511.1060908@sandeen.net>
	<CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>
In-Reply-To: <CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/6/15 1:05 PM, Chris Murphy wrote:
> On Tue, Jan 6, 2015 at 10:02 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> however, some drives lie about these sizes, and then mkfs.xfs can't know.
>> Try the blockdev command above to see.
> 
> blockdev and parted seem to get this wrong for a device for which
> smartctl and hdparm get correct

I don't think they get it wrong, they are just reporting what the
drive says over that interface.

I ... don't actually know where smartctl/hdparm get the values, vs.
the values exported to blockdev.  Is the drive reporting different
values over different query interfaces?  Hrm.

mkfs.xfs uses the same interface as used by blockdev.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
