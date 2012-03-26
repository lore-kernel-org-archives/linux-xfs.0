Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMAo6q102648 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:10:50 -0500
Message-ID: <4F70E951.50009@windriver.com>
Date: Mon, 26 Mar 2012 18:10:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
MIME-Version: 1.0
Subject: Re: Building tilegx defconfig gets init/exit section errors in xfs.
References: <4F6F61F3.40903@windriver.com> <20120326215919.GN5091@dastard>
In-Reply-To: <20120326215919.GN5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: bpm@sgi.com, linux-next@vger.kernel.org, cmetcalf@tilera.com, xfs@oss.sgi.com

On 12-03-26 05:59 PM, Dave Chinner wrote:
> On Sun, Mar 25, 2012 at 02:20:35PM -0400, Paul Gortmaker wrote:
>> Hi All,
>>
>> Recently the tilegx defconfig was added to the linux-next build
>> coverage, which exposed this.
>>  
>> LD      .tmp_vmlinux1
>> `xfs_qm_exit' referenced in section `.init.text' of fs/built-in.o:
>>  defined in discarded section `.exit.text' of fs/built-in.o
>> make[1]: *** [.tmp_vmlinux1] Error 1
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/5941293/
>>
>> It seemed odd to me, since I didn't think there was anything arch
>> specific in the init/exit sectioning, so I thought I'd mention it
>> here, just in case it hasn't been brought up before.
> 
> Already been reported, a patch has been provided, too. So the fix
> is underway.
> 
> Thanks for reporting the problem anyway, Paul.

Thanks Dave, Ben - seems gmane archive isn't easily searchable, but
the nabble one is.  I'll add this link to the linux-next triage
report until the fix appears in a linux-next build:

http://old.nabble.com/-PATCH--fs%3A-xfs%3A-fix-section-mismatch-in-linux-next-td33519270.html

And next time I'll try harder to search a useful archive.  :)

Paul.


> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
