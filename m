Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E4577FC3
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 08:46:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 467A0304051
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 06:46:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7fNA1CuauRY5R2Ac for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 06:46:25 -0700 (PDT)
Message-ID: <5213732F.4010900@sandeen.net>
Date: Tue, 20 Aug 2013 08:46:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673 V2
References: <1376945597-2202-1-git-send-email-jbacik@fusionio.com>
	<5213338D.3000205@giantdisaster.de>
In-Reply-To: <5213338D.3000205@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On 8/20/13 4:14 AM, Stefan Behrens wrote:
> On Mon, 19 Aug 2013 16:53:17 -0400, Josef Bacik wrote:
>> There was a problem with send trying to overwrite a file that wasn't actually
>> the same.  This is a test to check this particular case where receive fails when
>> it should succeed properly.  I tested this to verify it fails without my fix and
>> passes with my fix.  Thanks,
> 
> I tested this xfstest but for me it passes with and without the fix
> ("Btrfs: check our parent dir when doing a compare send").

is there any interesting fail-ish output in $seqres.full?

I wonder if it squawked about errors but exited w/ success.

>> $NOT_STDOUT 2>&1 can be dangerous ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
