Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGKkBjG118068 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 14:46:11 -0600
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2784313C5F36
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 12:47:43 -0800 (PST)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	6DNkA63P6d1LBrRK for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 12:47:43 -0800 (PST)
Received: by gye5 with SMTP id 5so878461gye.26
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 12:47:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101116160545.GA2524@localhost.localdomain>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
	<4CE2783F.1020004@redhat.com>
	<20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
	<4CE28211.6060204@redhat.com>
	<20101116160545.GA2524@localhost.localdomain>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Tue, 16 Nov 2010 12:47:20 -0800
Message-ID: <AANLkTikz07C_=aZudup7xSpLnrEYi5No4QhL5WD9xxTx@mail.gmail.com>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef Bacik <josef@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Avi Kivity <avi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Nov 16, 2010 at 8:05 AM, Josef Bacik <josef@redhat.com> wrote:
> On Tue, Nov 16, 2010 at 03:07:29PM +0200, Avi Kivity wrote:
>> On 11/16/2010 02:50 PM, Josef Bacik wrote:
>>> On Tue, Nov 16, 2010 at 02:25:35PM +0200, Avi Kivity wrote:
>>> > =A0On 11/15/2010 07:05 PM, Josef Bacik wrote:
>>> >> =A0Ext4 doesn't have the ability to punch holes yet, so make sure we=
 return
>>> >> =A0EOPNOTSUPP if we try to use hole punching through fallocate. =A0T=
his support can
>>> >> =A0be added later. =A0Thanks,
>>> >>
>>> >
>>> > =A0Instead of teaching filesystems to fail if they don't support the
>>> > =A0capability, why don't supporting filesystems say so, allowing the =
fail
>>> > =A0code to be in common code?
>>> >
>>>
>>> There is no simple way to test if a filesystem supports hole punching o=
r not so
>>> the check has to be done per fs. =A0Thanks,
>>
>> Could put a flag word in superblock_operations. =A0Filesystems which
>> support punching (or other features) can enable it there.
>>
>> Or even have its own callback.
>>
>
> Sure but then you have to do the same thing for every other flag you add =
to
> fallocate and then you have this huge mess of random flags just so you do=
n't
> call into the filesystem. =A0This way is a lesser of two evils I think. =
=A0Thanks,
>
> Josef

I'm not a true kernel hacker, so my opinion is not critical but I find
it hard to read / expand as

> +     /* We only support the FALLOC_FL_KEEP_SIZE mode */
> +     if (mode && (mode !=3D FALLOC_FL_KEEP_SIZE))
> +             return -EOPNOTSUPP;

How about:

#define EXT4_FALLOC_MODES_SUPPORTED (FALLOC_FL_KEEP_SIZE)

if (modes & ~EXT4_FALLOC_MODES_SUPPORTED)
             return -EOPNOTSUPP;


Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
