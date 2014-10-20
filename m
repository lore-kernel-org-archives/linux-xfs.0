Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B9227F4E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 18:23:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8395CAC002
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 16:23:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UD181HRUSW2BTV6P for <xfs@oss.sgi.com>;
	Mon, 20 Oct 2014 16:23:52 -0700 (PDT)
Message-ID: <54459988.2030803@sandeen.net>
Date: Mon, 20 Oct 2014 18:23:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Can't build RPM of xfstests
References: <648473255763364B961A02AC3BE1060D03C7940C13@MX19A.corp.emc.com>	<20141020014750.GL7169@dastard>
	<54448313.7040602@sandeen.net>
	<30CA1845-C213-49EA-8809-F1E7A98AE7F9@gmail.com>
In-Reply-To: <30CA1845-C213-49EA-8809-F1E7A98AE7F9@gmail.com>
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
To: Greg Freemyer <greg.freemyer@gmail.com>, Dave Chinner <david@fromorbit.com>, "Kaul, Yaniv" <Yaniv.Kaul@emc.com>
Cc: esandeen@redhat.com, fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 10/20/14 6:55 AM, Greg Freemyer wrote:
> 
> 
> On October 19, 2014 11:35:47 PM EDT, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 10/19/14 8:47 PM, Dave Chinner wrote:
>>> [ cc fstests@vger.kernel.org ]
>>
>> ...
>>
>>>> === rpm ===
>>>> /bin/sed -e's|@pkg_name@|xfstests|g' \
>>>> 	    -e's|@pkg_version@|1.1.1|g' \
>>>> 	    -e's|@pkg_release@|1|g' \
>>>> 	    -e's|@pkg_distribution@|Linux|g' \
>>>> 	    -e's|@build_root@|/tmp/34943|g' \
>>>> 	    -e'/^BuildRoot: *$/d' \
>>>> 	    -e's|@make@|/usr/bin/gmake|g' < xfstests.spec.in >
>> xfstests.spec
>>>> /usr/bin/rpmbuild -ba --rcfile ./rpm-4.rc xfstests.spec
>>>> error: File /root/rpmbuild/SOURCES/xfstests-1.1.1.src.tar.gz: No
>> such file or directory
>>>> gmake[1]: *** [dist] Error 1
>>>
>>> I've never tried to build xfstests packages, so I'd make the
>>> assumption that the package build infrastructure is broken and needs
>>> fixing.  That's looking for the tarball in the wrong place. My naive
>>> reading of that is rpmbuild is expecting to run as root, not as a
>>> jenkins user....
>>>
>>> Eric, you're the local RPM expert - any ideas?
>>>
>>> FWIW, I'll take whatever patches you guys come up with that make it
>>> build rpms properly. ;)
>>
>> xfstests rpms have just never been a priority for me.  I run it just
>> fine out
>> of a checked-out git repo, and it doesn't require installation; on the
>> other
>> hand, making it palatable for a proper FHS-compliant distro package
>> would
>> require a fair bit of restructuring beyond just the packaging scripts.
>>
>> And... I honestly have no idea how the Makepkgs stuff is supposed to
>> work.
>>
>> I've never been a fan of upstream containing packaging bits anyway;
>> different
>> distros have different requirements, and the Makepkgs script has always
>> seemed
>> weird.  RPM/specfiles are supposed to drive the build - the build isn't
>> supposed
>> to drive rpm.  I think it'd be best to make a distro-specific specfile
>> which knows how
>> to handle an xfstests tarball.  Trying to reverse engineer Makepkgs
>> doesn't sound
>> fun to me; rpmbuild knows how to do this stuff.  Dropping a generic RPM
>> specfile
>> into the top level dir would probably be enough to get it off the
>> ground even if
>> it doesn't conform to any particular distro's packaging rules.
>>
>> I think it's up to those who want rpms to dig into this, for now. 
>> Dumping all
>> files into /opt/xfstests is probably simplest, since FHS-compliance is
>> probably a
>> long ways off.
>>
>> -Eric
> 
> Opensuse is building rpms of 1.1.1 so the build infrastructure isn't
> too badly broken. I don't know if they are following FHS, but I doubt
> they use /opt.

Ok, they put it all into /var/lib - maybe that does satisfy LFS, I dunno.

> The opensuse package/specfile can be found at: https://build.opensuse.org/package/show/filesystems/xfstests
> 
> The rpms including the source rpm can be downloaded from:
> http://software.opensuse.org/download.html?project=filesystems&package=xfstests
> 
> Note the specfile applies a patch to change the install aspect of the tarball immediately after untar'ing it.  

Yep, doesn't do much - s/LTINSTALL/INSTALL/ pretty much.

Looks like a fine place to start.

Rather than using Makepkgs, it may make more sense to just drop a sane generic
.spec file into the top dir, then rpmbuild -ta <tarball> would work.

But then ... we don't distribute xfstests tarballs ... ;)

-Eric

> I don't maintain that so I don't know why the patch is needed.
> 
> Greg
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
