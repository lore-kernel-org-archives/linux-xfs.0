Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VNtpvj090709 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 18:55:51 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BBF7D76427
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:07:01 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id l4N16ARJgNEEyp6Y
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:07:01 -0700 (PDT)
Message-ID: <4C7D96AF.3000006@profihost.ag>
Date: Wed, 01 Sep 2010 01:56:31 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS Quota Check OOM
References: <4C7BA0A0.5090202@profihost.ag>
	<4C7CB0FE.1020302@profihost.ag>	<20100831104418.058ab6b5@galadriel.home>	<4C7CF4C4.9030105@profihost.ag>	<20100831144319.7e97acea@galadriel.home>	<4C7CFC08.1000708@profihost.ag>	<20100831152016.5d800e93@galadriel.home>	<4C7D03FA.4010106@profihost.ag>
	<20100831232817.GM705@dastard>
In-Reply-To: <20100831232817.GM705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

quota report returns nothing... :-( except two newlines...

# xfs_quota -x -c "report -phnN" /


#

Stefan

Am 01.09.2010 01:28, schrieb Dave Chinner:
> On Tue, Aug 31, 2010 at 03:30:34PM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi!
>>
>> After booting the System to a RAM Image with prjquota (the quota
>> check wents fine) and upgrading to xfsprogs 3.1.3.
>>
>> I'm getting this when trying to setup a project Quota:
>> xfs_quota -x -c "project -s 2" /
>> Setting up project 2 (path /serverbackup/abc)...
>> Processed 1 (/etc/projects and cmdline) paths for project 2 with
>> recursion depth infinite (-1).
>
> That's normal, I think. Adding project quota involves descending the
> directory heirachy specified and adding the project id to every file
> and directory. You can limit the recursion depth it runs to if you
> want to, but the default (infinite) is to walk the entire heirarchy.
>
> You can confirm by running a quota report and checking the output...
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
