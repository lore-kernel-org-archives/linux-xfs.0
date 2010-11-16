Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGG4UK0080871 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 10:04:30 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF5071851F6
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 08:06:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 02S1oSQfjaRjIzEX for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 08:06:02 -0800 (PST)
Date: Tue, 16 Nov 2010 11:05:46 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101116160545.GA2524@localhost.localdomain>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
	<4CE2783F.1020004@redhat.com>
	<20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
	<4CE28211.6060204@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CE28211.6060204@redhat.com>
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
To: Avi Kivity <avi@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Nov 16, 2010 at 03:07:29PM +0200, Avi Kivity wrote:
> On 11/16/2010 02:50 PM, Josef Bacik wrote:
>> On Tue, Nov 16, 2010 at 02:25:35PM +0200, Avi Kivity wrote:
>> >  On 11/15/2010 07:05 PM, Josef Bacik wrote:
>> >>  Ext4 doesn't have the ability to punch holes yet, so make sure we return
>> >>  EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
>> >>  be added later.  Thanks,
>> >>
>> >
>> >  Instead of teaching filesystems to fail if they don't support the
>> >  capability, why don't supporting filesystems say so, allowing the fail
>> >  code to be in common code?
>> >
>>
>> There is no simple way to test if a filesystem supports hole punching or not so
>> the check has to be done per fs.  Thanks,
>
> Could put a flag word in superblock_operations.  Filesystems which  
> support punching (or other features) can enable it there.
>
> Or even have its own callback.
>

Sure but then you have to do the same thing for every other flag you add to
fallocate and then you have this huge mess of random flags just so you don't
call into the filesystem.  This way is a lesser of two evils I think.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
