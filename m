Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A90657FC4
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:25:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8830E304071
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 10:25:28 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id gTZCAA5aZQbnDTnz for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 10:25:27 -0800 (PST)
Date: Thu, 7 Mar 2013 19:25:25 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: enhance ltp/fsx with a timeout option
Message-ID: <20130307182525.GA29541@suse.cz>
References: <1358944851-14336-1-git-send-email-dsterba@suse.cz>
	<51378B7F.9090103@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51378B7F.9090103@sgi.com>
Reply-To: dsterba@suse.cz
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

Hi,

On Wed, Mar 06, 2013 at 12:31:27PM -0600, Rich Johnston wrote:
> I used test 263 to verify that fsx works as expected with the new -T and the
> existing -N options.  With the -T option of course, test 263 will fail.  I
> don't suggest that we change existing tests but add new tests which use the
> new -T option. Do you have a new test which you intend to use the -T option
> that can be submitted with this patch?

I understand that changing behaviour of existing checks is not desirable.

The -T option to fsx was inspired by the test we used to hunt a bug at
3.8-rc time where 50 concurrent direct io fsx jobs triggered the bug in
about 10 minutes or it was considered fine.

fsx -q xxxf$x -Z -R -W -r 4096 -w 4096
(http://permalink.gmane.org/gmane.comp.file-systems.btrfs/22447)

I'll send this test integrated into xfstests harness.

david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
