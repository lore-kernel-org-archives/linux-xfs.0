Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QLrZfo100570 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 16:53:35 -0500
Date: Mon, 26 Mar 2012 16:53:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Building tilegx defconfig gets init/exit section errors in xfs.
Message-ID: <20120326215344.GX7762@sgi.com>
References: <4F6F61F3.40903@windriver.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F6F61F3.40903@windriver.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, cmetcalf@tilera.com, xfs@oss.sgi.com

Hey Paul,

On Sun, Mar 25, 2012 at 02:20:35PM -0400, Paul Gortmaker wrote:
> Recently the tilegx defconfig was added to the linux-next build
> coverage, which exposed this.
>  
> LD      .tmp_vmlinux1
> `xfs_qm_exit' referenced in section `.init.text' of fs/built-in.o:
>  defined in discarded section `.exit.text' of fs/built-in.o
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/5941293/
> 
> It seemed odd to me, since I didn't think there was anything arch
> specific in the init/exit sectioning, so I thought I'd mention it
> here, just in case it hasn't been brought up before.

Yep, this is fixed in the xfs master branch, and we'll be requesting a pull
ASAP.  Thanks for reporting it!  ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
