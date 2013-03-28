Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E8EC7CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 11:37:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D7468F8040
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 09:37:42 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qAZiS9DtFg8ZEkc4 for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 09:37:40 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 42CE7A3A49
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 17:37:40 +0100 (CET)
Date: Thu, 28 Mar 2013 17:37:38 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: remove unconditional setting of FSTYP
Message-ID: <20130328163738.GE29125@twin.jikos.cz>
References: <1364485147-27210-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364485147-27210-1-git-send-email-dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Mar 28, 2013 at 04:39:07PM +0100, David Sterba wrote:
> Commit 3345d2150e9e672 ("xfstests: clean up and simply check CLI option
> parsing") hardcodes the FSTYP to xfs, testing other filesystems fails
> with
> 
> common.rc: Error: $TEST_DEV (/dev/sda5) is not a MOUNTED xfs filesystem
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

That's not a complete fix, I haven't noticed the automatic fs detection via
blkid, however it does not work because HOSTOS is not set:

./check:
 53 # Autodetect fs type based on what's on $TEST_DEV
 54 if [ "$HOSTOS" == "Linux" ]; then
 55     FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
 56 fi

standalone "blkid -c /dev/null -s TYPE -o value $TEST_DEV`" works.

common/config:
 60 HOSTOS=`uname -s`

although 'uname -s' gives me Linux.


It works together with an explicit

export FSTYP=whatever


david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
