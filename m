Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFFEE7F5F
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 12:33:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 400B3AC002
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:33:26 -0700 (PDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
	[209.85.217.172]) by cuda.sgi.com with ESMTP id
	dDnYC8M2XlaLnmZd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:33:20 -0700 (PDT)
Received: by lbbwb3 with SMTP id wb3so88289673lbb.1
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:33:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5625182C.3050007@gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
	<CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
	<5625182C.3050007@gmail.com>
Date: Mon, 19 Oct 2015 19:33:19 +0200
Message-ID: <CAHc6FU75GXGeav1ho-QraPS_F8fpOXnoDyv17+b=koiF=9YE5A@mail.gmail.com>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Mon, Oct 19, 2015 at 6:19 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-19 11:34, Andreas Gruenbacher wrote:
>>
>> On Mon, Oct 19, 2015 at 3:16 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>>>
>>>>
>>>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>>
>>>>>
>>>>> I would like to re-iterate, on both XFS and ext4, I _really_ think this
>>>>> should be a ro_compat flag, and not an incompat one.  If a person has
>>>>> the
>>>>> ability to mount the FS (even if it's a read-only mount), then they by
>>>>> definition have read access to the file or partition that the
>>>>> filesystem
>>>>> is contained in, which means that any ACL's stored on the filesystem
>>>>> are
>>>>> functionally irrelevant,
>>>>
>>>>
>>>> It is unfortunately not safe to make such a file system accessible to
>>>> other users, so the feature is not strictly read-only compatible.
>>>>
>>> OK, seeing as I wasn't particularly clear as to why I object to this in
>>> my
>>> other e-mail, let's try this again.
>>>
>>> Can you please explain exactly why it isn't safe to make such a
>>> filesystem
>>> accessible to other users?
>>
>>
>> See here: http://www.spinics.net/lists/linux-ext4/msg49541.html
>
> OK, so to clarify, this isn't 'safe' because:
> 1. The richacls that exist on the filesystem won't be enforced.
> 2. Newly created files will have no ACL's set.
>
> It is worth noting that these are also issues with any kind of access
> control mechanism.  Using your logic, all LSM's need to set separate
> incompat feature flags in filesystems they are being used on, as should
> POSIX ACLs, and for that matter so should Samba in many circumstances, and
> any NFS system not using idmapping or synchronized/centralized user
> databases.  Now, if the SELinux (or SMACK, or TOMOYO) people had taken this
> approach, then I might be inclined to not complain (at least not to you, I'd
> be complaining to them about this rather poor design choice), but that is
> not the case, because (I assume) they realized that all this provides is a
> false sense of security.

LSMs reside above the filesystem level. Let's take SELinux as an
example. It has its own consistency check mechanism (relabeling). Fsck
could check the syntax of SELinux labels, but it couldn't do anything
sensible about corrupted labels, and syntactically correct labels also
don't mean much. A relabeling run to verify or restory the appropriate
policy would still be necessary to verify that labels are semantically
correct, and for that, the filesystem needs to be mounted in the right
place in the filesystem hierarchy.

TOMOYO and AppArmor are not based on inode labels at all.

LSMs usually also just provide an extra layer of security; when turned
off, the basic security mechanisms still in effect will make sure that
the system works just like before. (There are configurations like MLS
where that is not the case, but those are uncommon.)

ACLs are quite different from that. They can be checked statically by
fsck. They are a basic security concept, and when turned off, there is
no guarantee that the system will still be safe.

> Issue 1, as I have said before, is functionally irrelevant for anyone who
> actually knows what they are doing; all you need for ext* is one of the
> myriad of programs for un-deleting files on such a filesystem (such as
> ext4magic or extundelete, and good luck convincing them to not allow being
> used when this flag is set), for BTRFS you just need the regular filesystem
> administration utilities ('btrfs restore' works wonders, and that one will
> _never_ honor any kind of permissions, because it's for disaster recovery),
> and while I don't know of any way to do this with XFS, that is only because
> I don't use XFS myself and have not had the need to provide tech support for
> anyone who does.  If somebody absolutely _needs_ a guarantee that the acls
> will be enforced, they need to be using whole disk encryption, not just
> acls, and even that can't provide such a guarantee.
>
> As for issue 2, that can be solved by making it a read-only compatible flag,
> which is what I was suggesting be done in the first place.  The only
> situation I can think of that this would cause an issue for is if the
> filesystem was not cleanly unmounted, and the log-replay doesn't set the
> ACL's, but mounting an uncleanly unmounted filesystem that has richacls on a
> kernel without support should fall into one of the following 2 cases more
> than 99% of the time:
> 1. The system crashed hard, and the regular kernel is un-bootable for some
> reason, in this case you're at the point of disaster recovery, should not be
> exposing _anything_ to a multi-user environment, and probably care a lot
> more about being able to get the system running again than about not
> accidentally creating a file with a missing ACL.
> 2. The filesystem was maliciously stolen in some way (either the hardware
> was acquired, or more likely, someone got an image of a still mounted
> filesystem), in which case all of my statements above regarding issue 1
> apply.

Please spare me with all that nonsense. Compared to mount options,
filesystem feature flags in this case simplify things (you don't have
to specify whether a filesystem contains POSIX ACLs or richacls), and
they prevent administrator errors: when a filesystem mounts, it is
safe to use; when it doesn't, it is not. That's all there is to it.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
