Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4133729E1A
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 15:24:23 -0500 (CDT)
Message-ID: <518962FC.2060509@sgi.com>
Date: Tue, 07 May 2013 15:24:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
References: <20130507133707.GA18301@redhat.com> <51895025.2010709@sgi.com>
	<20130507190731.GA15528@redhat.com> <518954DE.4070803@sgi.com>
	<20130507193146.GA7539@redhat.com> <51895CD7.7040806@sgi.com>
	<20130507195954.GA8384@redhat.com> <51895E51.2050508@sgi.com>
	<20130507202217.GA9883@redhat.com>
In-Reply-To: <20130507202217.GA9883@redhat.com>
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
To: Dave Jones <davej@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On 05/07/13 15:22, Dave Jones wrote:
> On Tue, May 07, 2013 at 03:04:33PM -0500, Mark Tinguely wrote:
>   >  On 05/07/13 14:59, Dave Jones wrote:
>   >  >  On Tue, May 07, 2013 at 02:58:15PM -0500, Mark Tinguely wrote:
>   >  >
>   >  >    >   >   I can hit this almost instantly with fsx. I'll do a bisect, though
>   >  >    >   >   it sounds like you already have a suspect.
>   >  >    >   >
>   >  >    >
>   >  >    >   If you want to try kmem debug of Linux 3.8 that would help.
>   >  >
>   >  >  I'm not sure what that is.
>   >
>   >  Sorry, if you would test Linux 3.8 with "CONFIG_DEBUG_SLAB=y".
>
> Ah, done that. (I pretty much always run with it).
>
> This is something new. Even 3.9 was fine. It's only since
> the recent xfs merge.
>
> 	Dave
>

git revert 666d644cd72a9ec58b353209ff191d7430f3b357

until it gets fixed.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
