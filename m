Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMD2VP102786 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:13:02 -0500
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [206.83.70.75]) by
	cuda.sgi.com with ESMTP id 7xTsiTJTYHWA6FLm (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 15:13:01 -0700 (PDT)
Message-ID: <4F70E9EA.5010207@tilera.com>
Date: Mon, 26 Mar 2012 18:12:58 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
MIME-Version: 1.0
Subject: Re: Building tilegx defconfig gets init/exit section errors in xfs.
References: <4F6F61F3.40903@windriver.com> <20120326215919.GN5091@dastard>
	<4F70E951.50009@windriver.com>
In-Reply-To: <4F70E951.50009@windriver.com>
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
Cc: bpm@sgi.com, linux-next@vger.kernel.org, xfs@oss.sgi.com

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
> Already been reported, a patch has been provided, too. So the fix
> is underway.
>
> Thanks for reporting the problem anyway, Paul.

And I'll second that with my thanks for adding tilegx to the linux-next
build coverage!  Please do continue to cc me on any issues that are exposed.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
