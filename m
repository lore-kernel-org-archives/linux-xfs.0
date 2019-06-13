Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38833 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfFMVNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 17:13:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id v11so215510pgl.5
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 14:13:48 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <AE838C22-1A11-4F93-AB88-80CF009BD301@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_EA59EFD2-F69E-4324-A987-ABC5C770B932";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: pagecache locking (was: bcachefs status update) merged)
Date: Thu, 13 Jun 2019 15:13:40 -0600
In-Reply-To: <20190613183625.GA28171@kmo-pixel>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>


--Apple-Mail=_EA59EFD2-F69E-4324-A987-ABC5C770B932
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_20FAA3B9-CB10-4AA6-8146-ACB6B9D72F27"


--Apple-Mail=_20FAA3B9-CB10-4AA6-8146-ACB6B9D72F27
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 13, 2019, at 12:36 PM, Kent Overstreet =
<kent.overstreet@gmail.com> wrote:
>=20
> On Thu, Jun 13, 2019 at 09:02:24AM +1000, Dave Chinner wrote:
>> On Wed, Jun 12, 2019 at 12:21:44PM -0400, Kent Overstreet wrote:
>>> Ok, I'm totally on board with returning EDEADLOCK.
>>>=20
>>> Question: Would we be ok with returning EDEADLOCK for any IO where =
the buffer is
>>> in the same address space as the file being read/written to, even if =
the buffer
>>> and the IO don't technically overlap?
>>=20
>> I'd say that depends on the lock granularity. For a range lock,
>> we'd be able to do the IO for non-overlapping ranges. For a normal
>> mutex or rwsem, then we risk deadlock if the page fault triggers on
>> the same address space host as we already have locked for IO. That's
>> the case we currently handle with the second IO lock in XFS, ext4,
>> btrfs, etc (XFS_MMAPLOCK_* in XFS).
>>=20
>> One of the reasons I'm looking at range locks for XFS is to get rid
>> of the need for this second mmap lock, as there is no reason for it
>> existing if we can lock ranges and EDEADLOCK inside page faults and
>> return errors.
>=20
> My concern is that range locks are going to turn out to be both more =
complicated
> and heavier weight, performance wise, than the approach I've taken of =
just a
> single lock per address space.
>=20
> Reason being range locks only help when you've got multiple operations =
going on
> simultaneously that don't conflict - i.e. it's really only going to be =
useful
> for applications that are doing buffered IO and direct IO =
simultaneously to the
> same file. Personally, I think that would be a pretty gross thing to =
do and I'm
> not particularly interested in optimizing for that case myself... but, =
if you
> know of applications that do depend on that I might change my opinion. =
If not, I
> want to try and get the simpler, one-lock-per-address space approach =
to work.

There are definitely workloads that require multiple threads doing =
non-overlapping
writes to a single file in HPC.  This is becoming an increasingly common =
problem
as the number of cores on a single client increase, since there is =
typically one
thread per core trying to write to a shared file.  Using multiple files =
(one per
core) is possible, but that has file management issues for users when =
there are a
million cores running on the same job/file (obviously not on the same =
client node)
dumping data every hour.

We were just looking at this exact problem last week, and most of the =
threads are
spinning in grab_cache_page_nowait->add_to_page_cache_lru() and =
set_page_dirty()
when writing at 1.9GB/s when they could be writing at 5.8GB/s (when =
threads are
writing O_DIRECT instead of buffered).  Flame graph is attached for =
16-thread case,
but high-end systems today easily have 2-4x that many cores.

Any approach for range locks can't be worse than spending 80% of time =
spinning.

Cheers, Andreas





--Apple-Mail=_20FAA3B9-CB10-4AA6-8146-ACB6B9D72F27
Content-Disposition: inline;
	filename=shared_file_write.svg
Content-Type: image/svg+xml;
	x-unix-mode=0666;
	name="shared_file_write.svg"
Content-Transfer-Encoding: 7bit

<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" width="1200" height="566" onload="init(evt)" viewBox="0 0 1200 566" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<!-- Flame graph stack visualization. See https://github.com/brendangregg/FlameGraph for latest version, and http://www.brendangregg.com/flamegraphs.html for examples. -->
<!-- NOTES:  -->
<defs >
	<linearGradient id="background" y1="0" y2="1" x1="0" x2="0" >
		<stop stop-color="#eeeeee" offset="5%" />
		<stop stop-color="#eeeeb0" offset="95%" />
	</linearGradient>
</defs>
<style type="text/css">
	.func_g:hover { stroke:black; stroke-width:0.5; cursor:pointer; }
</style>
<script type="text/ecmascript">
<![CDATA[
	var details, searchbtn, matchedtxt, svg;
	function init(evt) {
		details = document.getElementById("details").firstChild;
		searchbtn = document.getElementById("search");
		matchedtxt = document.getElementById("matched");
		svg = document.getElementsByTagName("svg")[0];
		searching = 0;
	}

	// mouse-over for info
	function s(node) {		// show
		info = g_to_text(node);
		details.nodeValue = "Function: " + info;
	}
	function c() {			// clear
		details.nodeValue = ' ';
	}

	// ctrl-F for search
	window.addEventListener("keydown",function (e) {
		if (e.keyCode === 114 || (e.ctrlKey && e.keyCode === 70)) {
			e.preventDefault();
			search_prompt();
		}
	})

	// functions
	function find_child(parent, name, attr) {
		var children = parent.childNodes;
		for (var i=0; i<children.length;i++) {
			if (children[i].tagName == name)
				return (attr != undefined) ? children[i].attributes[attr].value : children[i];
		}
		return;
	}
	function orig_save(e, attr, val) {
		if (e.attributes["_orig_"+attr] != undefined) return;
		if (e.attributes[attr] == undefined) return;
		if (val == undefined) val = e.attributes[attr].value;
		e.setAttribute("_orig_"+attr, val);
	}
	function orig_load(e, attr) {
		if (e.attributes["_orig_"+attr] == undefined) return;
		e.attributes[attr].value = e.attributes["_orig_"+attr].value;
		e.removeAttribute("_orig_"+attr);
	}
	function g_to_text(e) {
		var text = find_child(e, "title").firstChild.nodeValue;
		return (text)
	}
	function g_to_func(e) {
		var func = g_to_text(e);
		// if there's any manipulation we want to do to the function
		// name before it's searched, do it here before returning.
		return (func);
	}
	function update_text(e) {
		var r = find_child(e, "rect");
		var t = find_child(e, "text");
		var w = parseFloat(r.attributes["width"].value) -3;
		var txt = find_child(e, "title").textContent.replace(/\([^(]*\)$/,"");
		t.attributes["x"].value = parseFloat(r.attributes["x"].value) +3;

		// Smaller than this size won't fit anything
		if (w < 2*12*0.59) {
			t.textContent = "";
			return;
		}

		t.textContent = txt;
		// Fit in full text width
		if (/^ *$/.test(txt) || t.getSubStringLength(0, txt.length) < w)
			return;

		for (var x=txt.length-2; x>0; x--) {
			if (t.getSubStringLength(0, x+2) <= w) {
				t.textContent = txt.substring(0,x) + "..";
				return;
			}
		}
		t.textContent = "";
	}

	// zoom
	function zoom_reset(e) {
		if (e.attributes != undefined) {
			orig_load(e, "x");
			orig_load(e, "width");
		}
		if (e.childNodes == undefined) return;
		for(var i=0, c=e.childNodes; i<c.length; i++) {
			zoom_reset(c[i]);
		}
	}
	function zoom_child(e, x, ratio) {
		if (e.attributes != undefined) {
			if (e.attributes["x"] != undefined) {
				orig_save(e, "x");
				e.attributes["x"].value = (parseFloat(e.attributes["x"].value) - x - 10) * ratio + 10;
				if(e.tagName == "text") e.attributes["x"].value = find_child(e.parentNode, "rect", "x") + 3;
			}
			if (e.attributes["width"] != undefined) {
				orig_save(e, "width");
				e.attributes["width"].value = parseFloat(e.attributes["width"].value) * ratio;
			}
		}

		if (e.childNodes == undefined) return;
		for(var i=0, c=e.childNodes; i<c.length; i++) {
			zoom_child(c[i], x-10, ratio);
		}
	}
	function zoom_parent(e) {
		if (e.attributes) {
			if (e.attributes["x"] != undefined) {
				orig_save(e, "x");
				e.attributes["x"].value = 10;
			}
			if (e.attributes["width"] != undefined) {
				orig_save(e, "width");
				e.attributes["width"].value = parseInt(svg.width.baseVal.value) - (10*2);
			}
		}
		if (e.childNodes == undefined) return;
		for(var i=0, c=e.childNodes; i<c.length; i++) {
			zoom_parent(c[i]);
		}
	}
	function zoom(node) {
		var attr = find_child(node, "rect").attributes;
		var width = parseFloat(attr["width"].value);
		var xmin = parseFloat(attr["x"].value);
		var xmax = parseFloat(xmin + width);
		var ymin = parseFloat(attr["y"].value);
		var ratio = (svg.width.baseVal.value - 2*10) / width;

		// XXX: Workaround for JavaScript float issues (fix me)
		var fudge = 0.0001;

		var unzoombtn = document.getElementById("unzoom");
		unzoombtn.style["opacity"] = "1.0";

		var el = document.getElementsByTagName("g");
		for(var i=0;i<el.length;i++){
			var e = el[i];
			var a = find_child(e, "rect").attributes;
			var ex = parseFloat(a["x"].value);
			var ew = parseFloat(a["width"].value);
			// Is it an ancestor
			if (0 == 0) {
				var upstack = parseFloat(a["y"].value) > ymin;
			} else {
				var upstack = parseFloat(a["y"].value) < ymin;
			}
			if (upstack) {
				// Direct ancestor
				if (ex <= xmin && (ex+ew+fudge) >= xmax) {
					e.style["opacity"] = "0.5";
					zoom_parent(e);
					e.onclick = function(e){unzoom(); zoom(this);};
					update_text(e);
				}
				// not in current path
				else
					e.style["display"] = "none";
			}
			// Children maybe
			else {
				// no common path
				if (ex < xmin || ex + fudge >= xmax) {
					e.style["display"] = "none";
				}
				else {
					zoom_child(e, xmin, ratio);
					e.onclick = function(e){zoom(this);};
					update_text(e);
				}
			}
		}
	}
	function unzoom() {
		var unzoombtn = document.getElementById("unzoom");
		unzoombtn.style["opacity"] = "0.0";

		var el = document.getElementsByTagName("g");
		for(i=0;i<el.length;i++) {
			el[i].style["display"] = "block";
			el[i].style["opacity"] = "1";
			zoom_reset(el[i]);
			update_text(el[i]);
		}
	}

	// search
	function reset_search() {
		var el = document.getElementsByTagName("rect");
		for (var i=0; i < el.length; i++) {
			orig_load(el[i], "fill")
		}
	}
	function search_prompt() {
		if (!searching) {
			var term = prompt("Enter a search term (regexp " +
			    "allowed, eg: ^ext4_)", "");
			if (term != null) {
				search(term)
			}
		} else {
			reset_search();
			searching = 0;
			searchbtn.style["opacity"] = "0.1";
			searchbtn.firstChild.nodeValue = "Search"
			matchedtxt.style["opacity"] = "0.0";
			matchedtxt.firstChild.nodeValue = ""
		}
	}
	function search(term) {
		var re = new RegExp(term);
		var el = document.getElementsByTagName("g");
		var matches = new Object();
		var maxwidth = 0;
		for (var i = 0; i < el.length; i++) {
			var e = el[i];
			if (e.attributes["class"].value != "func_g")
				continue;
			var func = g_to_func(e);
			var rect = find_child(e, "rect");
			if (rect == null) {
				// the rect might be wrapped in an anchor
				// if nameattr href is being used
				if (rect = find_child(e, "a")) {
				    rect = find_child(r, "rect");
				}
			}
			if (func == null || rect == null)
				continue;

			// Save max width. Only works as we have a root frame
			var w = parseFloat(rect.attributes["width"].value);
			if (w > maxwidth)
				maxwidth = w;

			if (func.match(re)) {
				// highlight
				var x = parseFloat(rect.attributes["x"].value);
				orig_save(rect, "fill");
				rect.attributes["fill"].value =
				    "rgb(230,0,230)";

				// remember matches
				if (matches[x] == undefined) {
					matches[x] = w;
				} else {
					if (w > matches[x]) {
						// overwrite with parent
						matches[x] = w;
					}
				}
				searching = 1;
			}
		}
		if (!searching)
			return;

		searchbtn.style["opacity"] = "1.0";
		searchbtn.firstChild.nodeValue = "Reset Search"

		// calculate percent matched, excluding vertical overlap
		var count = 0;
		var lastx = -1;
		var lastw = 0;
		var keys = Array();
		for (k in matches) {
			if (matches.hasOwnProperty(k))
				keys.push(k);
		}
		// sort the matched frames by their x location
		// ascending, then width descending
		keys.sort(function(a, b){
			return a - b;
		});
		// Step through frames saving only the biggest bottom-up frames
		// thanks to the sort order. This relies on the tree property
		// where children are always smaller than their parents.
		var fudge = 0.0001;	// JavaScript floating point
		for (var k in keys) {
			var x = parseFloat(keys[k]);
			var w = matches[keys[k]];
			if (x >= lastx + lastw - fudge) {
				count += w;
				lastx = x;
				lastw = w;
			}
		}
		// display matched percent
		matchedtxt.style["opacity"] = "1.0";
		pct = 100 * count / maxwidth;
		if (pct == 100)
			pct = "100"
		else
			pct = pct.toFixed(1)
		matchedtxt.firstChild.nodeValue = "Matched: " + pct + "%";
	}
	function searchover(e) {
		searchbtn.style["opacity"] = "1.0";
	}
	function searchout(e) {
		if (searching) {
			searchbtn.style["opacity"] = "1.0";
		} else {
			searchbtn.style["opacity"] = "0.1";
		}
	}
]]>
</script>
<rect x="0.0" y="0" width="1200.0" height="566.0" fill="url(#background)"  />
<text text-anchor="middle" x="600.00" y="24" font-size="17" font-family="Verdana" fill="rgb(0,0,0)"  >Flame Graph</text>
<text text-anchor="" x="10.00" y="549" font-size="12" font-family="Verdana" fill="rgb(0,0,0)" id="details" > </text>
<text text-anchor="" x="10.00" y="24" font-size="12" font-family="Verdana" fill="rgb(0,0,0)" id="unzoom" onclick="unzoom()" style="opacity:0.0;cursor:pointer" >Reset Zoom</text>
<text text-anchor="" x="1090.00" y="24" font-size="12" font-family="Verdana" fill="rgb(0,0,0)" id="search" onmouseover="searchover()" onmouseout="searchout()" onclick="search_prompt()" style="opacity:0.1;cursor:pointer" >Search</text>
<text text-anchor="" x="1090.00" y="549" font-size="12" font-family="Verdana" fill="rgb(0,0,0)" id="matched" > </text>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_vmpage_page (7 samples, 0.02%)</title><rect x="96.9" y="229" width="0.2" height="15.0" fill="rgb(236,57,12)" rx="2" ry="2" />
<text text-anchor="" x="99.87" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__mod_zone_page_state (4 samples, 0.01%)</title><rect x="103.9" y="181" width="0.1" height="15.0" fill="rgb(240,148,31)" rx="2" ry="2" />
<text text-anchor="" x="106.87" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_init (4 samples, 0.01%)</title><rect x="1172.9" y="341" width="0.1" height="15.0" fill="rgb(239,222,24)" rx="2" ry="2" />
<text text-anchor="" x="1175.94" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mem_cgroup_charge_common (300 samples, 0.69%)</title><rect x="599.4" y="181" width="8.1" height="15.0" fill="rgb(238,63,21)" rx="2" ry="2" />
<text text-anchor="" x="602.43" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_lru_reclaim (11 samples, 0.03%)</title><rect x="14.2" y="245" width="0.3" height="15.0" fill="rgb(218,209,48)" rx="2" ry="2" />
<text text-anchor="" x="17.24" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (5 samples, 0.01%)</title><rect x="87.7" y="133" width="0.2" height="15.0" fill="rgb(224,156,23)" rx="2" ry="2" />
<text text-anchor="" x="90.75" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (34 samples, 0.08%)</title><rect x="1170.5" y="165" width="1.0" height="15.0" fill="rgb(225,38,46)" rx="2" ry="2" />
<text text-anchor="" x="1173.54" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ldlm_lock_match_with_skip (5 samples, 0.01%)</title><rect x="14.7" y="229" width="0.1" height="15.0" fill="rgb(237,77,20)" rx="2" ry="2" />
<text text-anchor="" x="17.67" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[libpthread-2.17.so] (43,011 samples, 98.40%)</title><rect x="12.1" y="469" width="1161.1" height="15.0" fill="rgb(253,209,3)" rx="2" ry="2" />
<text text-anchor="" x="15.11" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >[libpthread-2.17.so]</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_make_ready (23 samples, 0.05%)</title><rect x="1175.1" y="245" width="0.6" height="15.0" fill="rgb(232,38,18)" rx="2" ry="2" />
<text text-anchor="" x="1178.10" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_state_set0 (9 samples, 0.02%)</title><rect x="674.2" y="181" width="0.2" height="15.0" fill="rgb(236,137,43)" rx="2" ry="2" />
<text text-anchor="" x="677.19" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mem_cgroup_charge_statistics.isra.21 (9 samples, 0.02%)</title><rect x="605.9" y="149" width="0.3" height="15.0" fill="rgb(229,184,42)" rx="2" ry="2" />
<text text-anchor="" x="608.91" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[unknown] (4 samples, 0.01%)</title><rect x="1189.9" y="485" width="0.1" height="15.0" fill="rgb(244,54,40)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>bit_wait_io (25 samples, 0.06%)</title><rect x="1181.9" y="325" width="0.7" height="15.0" fill="rgb(229,132,2)" rx="2" ry="2" />
<text text-anchor="" x="1184.90" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (17,339 samples, 39.67%)</title><rect x="131.1" y="165" width="468.0" height="15.0" fill="rgb(218,221,32)" rx="2" ry="2" />
<text text-anchor="" x="134.05" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >native_queued_spin_lock_slowpath</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>zone_statistics (17 samples, 0.04%)</title><rect x="110.2" y="165" width="0.5" height="15.0" fill="rgb(215,20,8)" rx="2" ry="2" />
<text text-anchor="" x="113.21" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>kmem_cache_alloc (5 samples, 0.01%)</title><rect x="92.1" y="133" width="0.2" height="15.0" fill="rgb(234,160,10)" rx="2" ry="2" />
<text text-anchor="" x="95.12" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_start (25 samples, 0.06%)</title><rect x="1175.0" y="325" width="0.7" height="15.0" fill="rgb(248,117,17)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>___slab_alloc (4 samples, 0.01%)</title><rect x="92.1" y="101" width="0.2" height="15.0" fill="rgb(221,31,46)" rx="2" ry="2" />
<text text-anchor="" x="95.15" y="111.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_add (18 samples, 0.04%)</title><rect x="96.4" y="181" width="0.5" height="15.0" fill="rgb(249,163,0)" rx="2" ry="2" />
<text text-anchor="" x="99.39" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (13 samples, 0.03%)</title><rect x="613.7" y="181" width="0.4" height="15.0" fill="rgb(205,192,50)" rx="2" ry="2" />
<text text-anchor="" x="616.71" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_lock_irqsave (6 samples, 0.01%)</title><rect x="618.7" y="165" width="0.1" height="15.0" fill="rgb(215,158,28)" rx="2" ry="2" />
<text text-anchor="" x="621.68" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_top (7 samples, 0.02%)</title><rect x="622.4" y="229" width="0.2" height="15.0" fill="rgb(212,93,10)" rx="2" ry="2" />
<text text-anchor="" x="625.43" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>get_task_policy.part.26 (4 samples, 0.01%)</title><rect x="111.6" y="213" width="0.1" height="15.0" fill="rgb(243,175,9)" rx="2" ry="2" />
<text text-anchor="" x="114.56" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__close_nocancel (13 samples, 0.03%)</title><rect x="1186.7" y="469" width="0.4" height="15.0" fill="rgb(214,210,4)" rx="2" ry="2" />
<text text-anchor="" x="1189.73" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lru_cache_add (150 samples, 0.34%)</title><rect x="615.7" y="213" width="4.0" height="15.0" fill="rgb(215,114,1)" rx="2" ry="2" />
<text text-anchor="" x="618.66" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_call.isra.7 (25 samples, 0.06%)</title><rect x="1175.0" y="341" width="0.7" height="15.0" fill="rgb(249,192,9)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__css_tryget (5 samples, 0.01%)</title><rect x="607.3" y="149" width="0.1" height="15.0" fill="rgb(241,126,27)" rx="2" ry="2" />
<text text-anchor="" x="610.26" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (9 samples, 0.02%)</title><rect x="102.3" y="197" width="0.2" height="15.0" fill="rgb(221,83,20)" rx="2" ry="2" />
<text text-anchor="" x="105.30" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (11 samples, 0.03%)</title><rect x="87.4" y="149" width="0.3" height="15.0" fill="rgb(212,94,45)" rx="2" ry="2" />
<text text-anchor="" x="90.42" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[libmlx4-rdmav2.so] (18 samples, 0.04%)</title><rect x="11.3" y="469" width="0.5" height="15.0" fill="rgb(227,144,3)" rx="2" ry="2" />
<text text-anchor="" x="14.27" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>rcu_check_callbacks (4 samples, 0.01%)</title><rect x="1161.9" y="53" width="0.1" height="15.0" fill="rgb(234,90,54)" rx="2" ry="2" />
<text text-anchor="" x="1164.90" y="63.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>do_notify_resume (9 samples, 0.02%)</title><rect x="1186.7" y="437" width="0.3" height="15.0" fill="rgb(234,119,54)" rx="2" ry="2" />
<text text-anchor="" x="1189.73" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__rmqueue (4 samples, 0.01%)</title><rect x="104.0" y="181" width="0.1" height="15.0" fill="rgb(247,158,11)" rx="2" ry="2" />
<text text-anchor="" x="106.97" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_enqueue_base (5 samples, 0.01%)</title><rect x="14.7" y="245" width="0.1" height="15.0" fill="rgb(250,218,1)" rx="2" ry="2" />
<text text-anchor="" x="17.67" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_lock_init (5 samples, 0.01%)</title><rect x="14.9" y="293" width="0.1" height="15.0" fill="rgb(236,220,38)" rx="2" ry="2" />
<text text-anchor="" x="17.91" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__radix_tree_create (54 samples, 0.12%)</title><rect x="86.0" y="149" width="1.4" height="15.0" fill="rgb(235,42,35)" rx="2" ry="2" />
<text text-anchor="" x="88.97" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_commit_async (20,035 samples, 45.84%)</title><rect x="631.3" y="245" width="540.9" height="15.0" fill="rgb(221,219,54)" rx="2" ry="2" />
<text text-anchor="" x="634.32" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >osc_io_commit_async</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_list_del (214 samples, 0.49%)</title><rect x="631.8" y="229" width="5.8" height="15.0" fill="rgb(247,228,8)" rx="2" ry="2" />
<text text-anchor="" x="634.77" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__percpu_counter_add (5 samples, 0.01%)</title><rect x="683.9" y="181" width="0.1" height="15.0" fill="rgb(245,112,44)" rx="2" ry="2" />
<text text-anchor="" x="686.90" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__schedule (92 samples, 0.21%)</title><rect x="1187.4" y="309" width="2.4" height="15.0" fill="rgb(210,74,5)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_fsync_start (218 samples, 0.50%)</title><rect x="1175.7" y="245" width="5.9" height="15.0" fill="rgb(217,35,7)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__radix_tree_preload (16 samples, 0.04%)</title><rect x="91.8" y="149" width="0.5" height="15.0" fill="rgb(223,5,10)" rx="2" ry="2" />
<text text-anchor="" x="94.83" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lovsub_attr_update (4 samples, 0.01%)</title><rect x="668.7" y="197" width="0.1" height="15.0" fill="rgb(237,0,47)" rx="2" ry="2" />
<text text-anchor="" x="671.68" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mca_pml_ob1_progress (10 samples, 0.02%)</title><rect x="1183.9" y="485" width="0.3" height="15.0" fill="rgb(244,71,38)" rx="2" ry="2" />
<text text-anchor="" x="1186.93" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__libc_fsync (292 samples, 0.67%)</title><rect x="1175.0" y="485" width="7.9" height="15.0" fill="rgb(210,213,46)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_enter_cache_try.constprop.36 (98 samples, 0.22%)</title><rect x="655.8" y="197" width="2.6" height="15.0" fill="rgb(246,24,53)" rx="2" ry="2" />
<text text-anchor="" x="658.77" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>tick_sched_timer (24 samples, 0.05%)</title><rect x="1161.7" y="101" width="0.6" height="15.0" fill="rgb(235,177,3)" rx="2" ry="2" />
<text text-anchor="" x="1164.65" y="111.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_state_set0 (8 samples, 0.02%)</title><rect x="66.8" y="229" width="0.2" height="15.0" fill="rgb(228,19,32)" rx="2" ry="2" />
<text text-anchor="" x="69.83" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_sync_file_range (25 samples, 0.06%)</title><rect x="1175.0" y="405" width="0.7" height="15.0" fill="rgb(249,18,46)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>search_binary_handler (4 samples, 0.01%)</title><rect x="1189.9" y="421" width="0.1" height="15.0" fill="rgb(218,33,22)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>find_get_pages_tag (4 samples, 0.01%)</title><rect x="1181.7" y="341" width="0.1" height="15.0" fill="rgb(253,191,16)" rx="2" ry="2" />
<text text-anchor="" x="1184.69" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_cancel (6 samples, 0.01%)</title><rect x="1172.7" y="309" width="0.1" height="15.0" fill="rgb(221,191,38)" rx="2" ry="2" />
<text text-anchor="" x="1175.67" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (17,192 samples, 39.33%)</title><rect x="693.4" y="149" width="464.1" height="15.0" fill="rgb(233,176,46)" rx="2" ry="2" />
<text text-anchor="" x="696.38" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >native_queued_spin_lock_slowpath</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sys_sched_setaffinity (92 samples, 0.21%)</title><rect x="1187.4" y="421" width="2.4" height="15.0" fill="rgb(228,169,24)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__radix_tree_preload (6 samples, 0.01%)</title><rect x="614.1" y="181" width="0.2" height="15.0" fill="rgb(223,12,41)" rx="2" ry="2" />
<text text-anchor="" x="617.15" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[unknown] (120 samples, 0.27%)</title><rect x="1186.6" y="485" width="3.3" height="15.0" fill="rgb(216,49,45)" rx="2" ry="2" />
<text text-anchor="" x="1189.63" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_iter_init (73 samples, 0.17%)</title><rect x="12.6" y="309" width="2.0" height="15.0" fill="rgb(244,195,52)" rx="2" ry="2" />
<text text-anchor="" x="15.59" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>wait_for_completion (92 samples, 0.21%)</title><rect x="1187.4" y="357" width="2.4" height="15.0" fill="rgb(253,103,18)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[libopen-pal.so.20.10.5] (13 samples, 0.03%)</title><rect x="11.8" y="469" width="0.3" height="15.0" fill="rgb(250,21,17)" rx="2" ry="2" />
<text text-anchor="" x="14.75" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[libmlx4-rdmav2.so] (38 samples, 0.09%)</title><rect x="10.1" y="485" width="1.0" height="15.0" fill="rgb(212,97,27)" rx="2" ry="2" />
<text text-anchor="" x="13.08" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_init (9 samples, 0.02%)</title><rect x="14.8" y="309" width="0.2" height="15.0" fill="rgb(221,130,30)" rx="2" ry="2" />
<text text-anchor="" x="17.81" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>iov_iter_copy_from_user_atomic (10 samples, 0.02%)</title><rect x="54.8" y="261" width="0.2" height="15.0" fill="rgb(215,67,50)" rx="2" ry="2" />
<text text-anchor="" x="57.76" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_enqueue (7 samples, 0.02%)</title><rect x="14.6" y="277" width="0.2" height="15.0" fill="rgb(205,57,36)" rx="2" ry="2" />
<text text-anchor="" x="17.62" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>hrtimer_interrupt (28 samples, 0.06%)</title><rect x="1161.6" y="133" width="0.7" height="15.0" fill="rgb(214,107,26)" rx="2" ry="2" />
<text text-anchor="" x="1164.57" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>set_cpus_allowed_ptr (92 samples, 0.21%)</title><rect x="1187.4" y="389" width="2.4" height="15.0" fill="rgb(252,105,2)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>btl_openib_component_progress (22 samples, 0.05%)</title><rect x="1183.0" y="485" width="0.6" height="15.0" fill="rgb(209,96,13)" rx="2" ry="2" />
<text text-anchor="" x="1185.98" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_sub_get (5 samples, 0.01%)</title><rect x="84.3" y="181" width="0.2" height="15.0" fill="rgb(247,191,47)" rx="2" ry="2" />
<text text-anchor="" x="87.35" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_merge_attr (11 samples, 0.03%)</title><rect x="1172.4" y="293" width="0.3" height="15.0" fill="rgb(231,203,39)" rx="2" ry="2" />
<text text-anchor="" x="1175.37" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[unknown] (13 samples, 0.03%)</title><rect x="11.8" y="453" width="0.3" height="15.0" fill="rgb(251,190,31)" rx="2" ry="2" />
<text text-anchor="" x="14.75" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_file_io_generic (43,002 samples, 98.38%)</title><rect x="12.3" y="373" width="1160.9" height="15.0" fill="rgb(224,133,21)" rx="2" ry="2" />
<text text-anchor="" x="15.32" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >ll_file_io_generic</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[unknown] (43,109 samples, 98.63%)</title><rect x="11.3" y="485" width="1163.7" height="15.0" fill="rgb(250,217,11)" rx="2" ry="2" />
<text text-anchor="" x="14.27" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >[unknown]</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ktime_get_ts64 (35 samples, 0.08%)</title><rect x="657.4" y="149" width="1.0" height="15.0" fill="rgb(245,16,36)" rx="2" ry="2" />
<text text-anchor="" x="660.42" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_top (9 samples, 0.02%)</title><rect x="672.8" y="213" width="0.2" height="15.0" fill="rgb(224,187,24)" rx="2" ry="2" />
<text text-anchor="" x="675.78" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>iov_iter_fault_in_readable (14 samples, 0.03%)</title><rect x="630.2" y="277" width="0.4" height="15.0" fill="rgb(231,129,7)" rx="2" ry="2" />
<text text-anchor="" x="633.18" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_list_add (8 samples, 0.02%)</title><rect x="622.6" y="245" width="0.2" height="15.0" fill="rgb(214,97,16)" rx="2" ry="2" />
<text text-anchor="" x="625.62" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>set_page_dirty (5 samples, 0.01%)</title><rect x="672.0" y="229" width="0.1" height="15.0" fill="rgb(215,101,21)" rx="2" ry="2" />
<text text-anchor="" x="674.97" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>add_to_page_cache_lru (18,827 samples, 43.07%)</title><rect x="111.8" y="229" width="508.2" height="15.0" fill="rgb(205,84,53)" rx="2" ry="2" />
<text text-anchor="" x="114.78" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >add_to_page_cache_lru</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_cache_writeback_range (218 samples, 0.50%)</title><rect x="1175.7" y="229" width="5.9" height="15.0" fill="rgb(254,91,35)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_preload (22 samples, 0.05%)</title><rect x="91.7" y="165" width="0.6" height="15.0" fill="rgb(217,213,49)" rx="2" ry="2" />
<text text-anchor="" x="94.66" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>opal_progress (5 samples, 0.01%)</title><rect x="1174.7" y="469" width="0.2" height="15.0" fill="rgb(218,16,48)" rx="2" ry="2" />
<text text-anchor="" x="1177.72" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>delete_from_page_cache (7 samples, 0.02%)</title><rect x="14.3" y="165" width="0.2" height="15.0" fill="rgb(234,165,42)" rx="2" ry="2" />
<text text-anchor="" x="17.29" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_find (1,118 samples, 2.56%)</title><rect x="67.0" y="245" width="30.2" height="15.0" fill="rgb(222,35,8)" rx="2" ry="2" />
<text text-anchor="" x="70.04" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >cl..</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_update_next_shrink (49 samples, 0.11%)</title><rect x="657.1" y="181" width="1.3" height="15.0" fill="rgb(251,40,40)" rx="2" ry="2" />
<text text-anchor="" x="660.10" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_assume (33 samples, 0.08%)</title><rect x="66.2" y="245" width="0.8" height="15.0" fill="rgb(233,107,1)" rx="2" ry="2" />
<text text-anchor="" x="69.15" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_start (218 samples, 0.50%)</title><rect x="1175.7" y="309" width="5.9" height="15.0" fill="rgb(217,149,41)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__wake_up_bit (10 samples, 0.02%)</title><rect x="674.9" y="149" width="0.3" height="15.0" fill="rgb(207,152,33)" rx="2" ry="2" />
<text text-anchor="" x="677.91" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_del_entry (4 samples, 0.01%)</title><rect x="109.1" y="149" width="0.1" height="15.0" fill="rgb(220,10,9)" rx="2" ry="2" />
<text text-anchor="" x="112.08" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_put (8 samples, 0.02%)</title><rect x="675.7" y="213" width="0.2" height="15.0" fill="rgb(249,214,9)" rx="2" ry="2" />
<text text-anchor="" x="678.70" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__hrtimer_run_queues (27 samples, 0.06%)</title><rect x="1161.6" y="117" width="0.7" height="15.0" fill="rgb(238,77,3)" rx="2" ry="2" />
<text text-anchor="" x="1164.57" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_make_ready (214 samples, 0.49%)</title><rect x="1175.8" y="181" width="5.8" height="15.0" fill="rgb(251,167,54)" rx="2" ry="2" />
<text text-anchor="" x="1178.83" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_iter_init (71 samples, 0.16%)</title><rect x="12.6" y="293" width="1.9" height="15.0" fill="rgb(220,170,37)" rx="2" ry="2" />
<text text-anchor="" x="15.62" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>finish_task_switch (92 samples, 0.21%)</title><rect x="1187.4" y="293" width="2.4" height="15.0" fill="rgb(245,157,53)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>unlock_page (28 samples, 0.06%)</title><rect x="674.8" y="165" width="0.8" height="15.0" fill="rgb(246,229,52)" rx="2" ry="2" />
<text text-anchor="" x="677.81" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_slice_add (39 samples, 0.09%)</title><rect x="95.8" y="197" width="1.1" height="15.0" fill="rgb(212,97,31)" rx="2" ry="2" />
<text text-anchor="" x="98.82" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__generic_file_write_iter (22,793 samples, 52.15%)</title><rect x="15.3" y="309" width="615.3" height="15.0" fill="rgb(226,91,0)" rx="2" ry="2" />
<text text-anchor="" x="18.29" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >__generic_file_write_iter</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_io_write_start (42,873 samples, 98.09%)</title><rect x="15.3" y="325" width="1157.4" height="15.0" fill="rgb(218,79,35)" rx="2" ry="2" />
<text text-anchor="" x="18.26" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >vvp_io_write_start</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>discard_pagevec (10 samples, 0.02%)</title><rect x="14.3" y="213" width="0.2" height="15.0" fill="rgb(220,75,33)" rx="2" ry="2" />
<text text-anchor="" x="17.27" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>read_tsc (6 samples, 0.01%)</title><rect x="658.2" y="133" width="0.2" height="15.0" fill="rgb(242,27,30)" rx="2" ry="2" />
<text text-anchor="" x="661.20" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_lru_alloc (117 samples, 0.27%)</title><rect x="88.2" y="165" width="3.1" height="15.0" fill="rgb(234,37,5)" rx="2" ry="2" />
<text text-anchor="" x="91.18" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_lock_irqsave (17 samples, 0.04%)</title><rect x="1175.2" y="197" width="0.4" height="15.0" fill="rgb(209,221,17)" rx="2" ry="2" />
<text text-anchor="" x="1178.15" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_enter_cache_try.constprop.36 (4 samples, 0.01%)</title><rect x="643.5" y="213" width="0.2" height="15.0" fill="rgb(224,18,24)" rx="2" ry="2" />
<text text-anchor="" x="646.54" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_page_state (9 samples, 0.02%)</title><rect x="681.7" y="181" width="0.3" height="15.0" fill="rgb(251,47,24)" rx="2" ry="2" />
<text text-anchor="" x="684.72" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>task_tick_fair (11 samples, 0.03%)</title><rect x="615.1" y="69" width="0.3" height="15.0" fill="rgb(241,150,53)" rx="2" ry="2" />
<text text-anchor="" x="618.12" y="79.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_prep_async_page (12 samples, 0.03%)</title><rect x="91.3" y="165" width="0.4" height="15.0" fill="rgb(252,205,21)" rx="2" ry="2" />
<text text-anchor="" x="94.34" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_top (5 samples, 0.01%)</title><rect x="66.6" y="229" width="0.2" height="15.0" fill="rgb(233,7,48)" rx="2" ry="2" />
<text text-anchor="" x="69.64" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_writepages (218 samples, 0.50%)</title><rect x="1175.7" y="357" width="5.9" height="15.0" fill="rgb(244,153,25)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock_irq (7 samples, 0.02%)</title><rect x="14.3" y="149" width="0.2" height="15.0" fill="rgb(206,158,3)" rx="2" ry="2" />
<text text-anchor="" x="17.29" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_end (7 samples, 0.02%)</title><rect x="12.4" y="325" width="0.2" height="15.0" fill="rgb(208,186,17)" rx="2" ry="2" />
<text text-anchor="" x="15.40" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>remove_commit_idr_uobject (5 samples, 0.01%)</title><rect x="11.1" y="357" width="0.2" height="15.0" fill="rgb(213,122,20)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>opal_timer_linux_get_cycles_sys_timer (7 samples, 0.02%)</title><rect x="1174.9" y="469" width="0.1" height="15.0" fill="rgb(247,192,12)" rx="2" ry="2" />
<text text-anchor="" x="1177.86" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__kprobes_text_start (4 samples, 0.01%)</title><rect x="1188.9" y="245" width="0.1" height="15.0" fill="rgb(227,104,40)" rx="2" ry="2" />
<text text-anchor="" x="1191.92" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__kmalloc (71 samples, 0.16%)</title><rect x="76.7" y="213" width="1.9" height="15.0" fill="rgb(222,96,1)" rx="2" ry="2" />
<text text-anchor="" x="79.65" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (17,192 samples, 39.33%)</title><rect x="693.4" y="165" width="464.1" height="15.0" fill="rgb(232,149,4)" rx="2" ry="2" />
<text text-anchor="" x="696.38" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >queued_spin_lock_slowpath</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__slab_alloc (50 samples, 0.11%)</title><rect x="77.2" y="197" width="1.4" height="15.0" fill="rgb(244,82,41)" rx="2" ry="2" />
<text text-anchor="" x="80.22" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (17 samples, 0.04%)</title><rect x="1175.2" y="181" width="0.4" height="15.0" fill="rgb(251,183,16)" rx="2" ry="2" />
<text text-anchor="" x="1178.15" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>do_fsync (292 samples, 0.67%)</title><rect x="1175.0" y="437" width="7.9" height="15.0" fill="rgb(254,64,24)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>load_elf_binary (4 samples, 0.01%)</title><rect x="1189.9" y="405" width="0.1" height="15.0" fill="rgb(243,186,47)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>next_zones_zonelist (12 samples, 0.03%)</title><rect x="110.7" y="181" width="0.3" height="15.0" fill="rgb(219,171,39)" rx="2" ry="2" />
<text text-anchor="" x="113.72" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__mark_inode_dirty (72 samples, 0.16%)</title><rect x="682.0" y="181" width="1.9" height="15.0" fill="rgb(253,111,6)" rx="2" ry="2" />
<text text-anchor="" x="684.96" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>apic_timer_interrupt (43 samples, 0.10%)</title><rect x="614.4" y="213" width="1.2" height="15.0" fill="rgb(223,73,21)" rx="2" ry="2" />
<text text-anchor="" x="617.44" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_loop (42,989 samples, 98.35%)</title><rect x="12.4" y="357" width="1160.5" height="15.0" fill="rgb(245,171,41)" rx="2" ry="2" />
<text text-anchor="" x="15.40" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >cl_io_loop</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>setup_new_exec (4 samples, 0.01%)</title><rect x="1189.9" y="389" width="0.1" height="15.0" fill="rgb(215,88,37)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_put (186 samples, 0.43%)</title><rect x="632.4" y="213" width="5.0" height="15.0" fill="rgb(249,192,4)" rx="2" ry="2" />
<text text-anchor="" x="635.37" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__generic_file_aio_write (22,793 samples, 52.15%)</title><rect x="15.3" y="293" width="615.3" height="15.0" fill="rgb(240,44,37)" rx="2" ry="2" />
<text text-anchor="" x="18.29" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >__generic_file_aio_write</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>prepare_to_wait (7 samples, 0.02%)</title><rect x="1182.7" y="325" width="0.2" height="15.0" fill="rgb(223,204,7)" rx="2" ry="2" />
<text text-anchor="" x="1185.68" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_call.isra.7 (218 samples, 0.50%)</title><rect x="1175.7" y="277" width="5.9" height="15.0" fill="rgb(211,130,53)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_extent_find (6 samples, 0.01%)</title><rect x="658.4" y="197" width="0.2" height="15.0" fill="rgb(220,130,19)" rx="2" ry="2" />
<text text-anchor="" x="661.42" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_slice_add (14 samples, 0.03%)</title><rect x="82.0" y="181" width="0.4" height="15.0" fill="rgb(234,106,19)" rx="2" ry="2" />
<text text-anchor="" x="85.00" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_add (4 samples, 0.01%)</title><rect x="82.3" y="165" width="0.1" height="15.0" fill="rgb(247,44,49)" rx="2" ry="2" />
<text text-anchor="" x="85.27" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>generic_file_buffered_write (22,684 samples, 51.90%)</title><rect x="17.7" y="277" width="612.3" height="15.0" fill="rgb(226,154,5)" rx="2" ry="2" />
<text text-anchor="" x="20.67" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >generic_file_buffered_write</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sched_setaffinity@@GLIBC_2.3.4 (93 samples, 0.21%)</title><rect x="1187.3" y="453" width="2.5" height="15.0" fill="rgb(216,180,11)" rx="2" ry="2" />
<text text-anchor="" x="1190.33" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__test_set_page_writeback (209 samples, 0.48%)</title><rect x="1175.9" y="149" width="5.6" height="15.0" fill="rgb(223,180,0)" rx="2" ry="2" />
<text text-anchor="" x="1178.88" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_pagevec_put (183 samples, 0.42%)</title><rect x="632.4" y="197" width="5.0" height="15.0" fill="rgb(207,195,51)" rx="2" ry="2" />
<text text-anchor="" x="635.45" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[libpthread-2.17.so] (6 samples, 0.01%)</title><rect x="11.1" y="485" width="0.2" height="15.0" fill="rgb(211,116,26)" rx="2" ry="2" />
<text text-anchor="" x="14.11" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_end_wrapper (6 samples, 0.01%)</title><rect x="12.4" y="293" width="0.2" height="15.0" fill="rgb(238,86,49)" rx="2" ry="2" />
<text text-anchor="" x="15.43" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ompi_coll_libnbc_progress (6 samples, 0.01%)</title><rect x="1184.2" y="485" width="0.2" height="15.0" fill="rgb(250,48,10)" rx="2" ry="2" />
<text text-anchor="" x="1187.20" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>call_softirq (7 samples, 0.02%)</title><rect x="1161.4" y="117" width="0.2" height="15.0" fill="rgb(208,43,24)" rx="2" ry="2" />
<text text-anchor="" x="1164.38" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__mod_zone_page_state (10 samples, 0.02%)</title><rect x="107.3" y="165" width="0.2" height="15.0" fill="rgb(239,149,27)" rx="2" ry="2" />
<text text-anchor="" x="110.27" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__set_page_dirty_nobuffers (18,267 samples, 41.79%)</title><rect x="678.4" y="197" width="493.1" height="15.0" fill="rgb(224,48,16)" rx="2" ry="2" />
<text text-anchor="" x="681.40" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >__set_page_dirty_nobuffers</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_lookup_slot (161 samples, 0.37%)</title><rect x="98.2" y="213" width="4.3" height="15.0" fill="rgb(251,102,52)" rx="2" ry="2" />
<text text-anchor="" x="101.20" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__slab_alloc (4 samples, 0.01%)</title><rect x="92.1" y="117" width="0.2" height="15.0" fill="rgb(218,43,31)" rx="2" ry="2" />
<text text-anchor="" x="95.15" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_lock_irqsave (6 samples, 0.01%)</title><rect x="1182.7" y="309" width="0.2" height="15.0" fill="rgb(231,174,8)" rx="2" ry="2" />
<text text-anchor="" x="1185.71" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_iter_init (58 samples, 0.13%)</title><rect x="12.6" y="261" width="1.6" height="15.0" fill="rgb(237,10,4)" rx="2" ry="2" />
<text text-anchor="" x="15.65" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>account_page_dirtied (128 samples, 0.29%)</title><rect x="1157.8" y="181" width="3.5" height="15.0" fill="rgb(243,16,22)" rx="2" ry="2" />
<text text-anchor="" x="1160.85" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_end (6 samples, 0.01%)</title><rect x="12.4" y="277" width="0.2" height="15.0" fill="rgb(251,225,20)" rx="2" ry="2" />
<text text-anchor="" x="15.43" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vfs_write (5 samples, 0.01%)</title><rect x="11.1" y="437" width="0.2" height="15.0" fill="rgb(210,103,11)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_slice_add (6 samples, 0.01%)</title><rect x="88.0" y="165" width="0.2" height="15.0" fill="rgb(226,61,32)" rx="2" ry="2" />
<text text-anchor="" x="90.99" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ior (43,585 samples, 99.71%)</title><rect x="10.0" y="501" width="1176.6" height="15.0" fill="rgb(206,221,38)" rx="2" ry="2" />
<text text-anchor="" x="13.00" y="511.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >ior</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__mem_cgroup_try_charge (34 samples, 0.08%)</title><rect x="606.5" y="165" width="1.0" height="15.0" fill="rgb(226,64,41)" rx="2" ry="2" />
<text text-anchor="" x="609.53" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>stripe_width (10 samples, 0.02%)</title><rect x="92.3" y="181" width="0.3" height="15.0" fill="rgb(232,208,50)" rx="2" ry="2" />
<text text-anchor="" x="95.34" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>iov_iter_fault_in_readable (43 samples, 0.10%)</title><rect x="55.0" y="261" width="1.2" height="15.0" fill="rgb(254,147,52)" rx="2" ry="2" />
<text text-anchor="" x="58.03" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>alloc_pages_current (327 samples, 0.75%)</title><rect x="102.7" y="213" width="8.9" height="15.0" fill="rgb(227,148,53)" rx="2" ry="2" />
<text text-anchor="" x="105.73" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (48 samples, 0.11%)</title><rect x="660.0" y="149" width="1.3" height="15.0" fill="rgb(241,149,11)" rx="2" ry="2" />
<text text-anchor="" x="663.04" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sys_fsync (292 samples, 0.67%)</title><rect x="1175.0" y="453" width="7.9" height="15.0" fill="rgb(213,101,34)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mark_page_accessed (242 samples, 0.55%)</title><rect x="623.4" y="261" width="6.5" height="15.0" fill="rgb(232,212,18)" rx="2" ry="2" />
<text text-anchor="" x="626.41" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (49 samples, 0.11%)</title><rect x="660.0" y="181" width="1.3" height="15.0" fill="rgb(242,122,33)" rx="2" ry="2" />
<text text-anchor="" x="663.01" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_state (8 samples, 0.02%)</title><rect x="110.5" y="149" width="0.2" height="15.0" fill="rgb(253,69,25)" rx="2" ry="2" />
<text text-anchor="" x="113.45" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>policy_zonelist (6 samples, 0.01%)</title><rect x="111.4" y="197" width="0.2" height="15.0" fill="rgb(231,198,27)" rx="2" ry="2" />
<text text-anchor="" x="114.40" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (12 samples, 0.03%)</title><rect x="87.1" y="133" width="0.3" height="15.0" fill="rgb(243,210,4)" rx="2" ry="2" />
<text text-anchor="" x="90.10" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__kprobes_text_start (30 samples, 0.07%)</title><rect x="1187.4" y="277" width="0.8" height="15.0" fill="rgb(242,2,49)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lprocfs_counter_add (4 samples, 0.01%)</title><rect x="97.1" y="229" width="0.1" height="15.0" fill="rgb(221,113,1)" rx="2" ry="2" />
<text text-anchor="" x="100.09" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lookup_page_cgroup (6 samples, 0.01%)</title><rect x="619.1" y="149" width="0.1" height="15.0" fill="rgb(236,195,26)" rx="2" ry="2" />
<text text-anchor="" x="622.06" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_lock_enqueue (8 samples, 0.02%)</title><rect x="14.6" y="293" width="0.2" height="15.0" fill="rgb(234,229,47)" rx="2" ry="2" />
<text text-anchor="" x="17.59" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>scheduler_tick (10 samples, 0.02%)</title><rect x="1162.0" y="53" width="0.3" height="15.0" fill="rgb(223,8,40)" rx="2" ry="2" />
<text text-anchor="" x="1165.03" y="63.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mca_btl_vader_component_progress (43 samples, 0.10%)</title><rect x="1173.5" y="469" width="1.1" height="15.0" fill="rgb(210,194,3)" rx="2" ry="2" />
<text text-anchor="" x="1176.45" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_file_aio_write (43,004 samples, 98.38%)</title><rect x="12.3" y="389" width="1160.9" height="15.0" fill="rgb(222,124,24)" rx="2" ry="2" />
<text text-anchor="" x="15.27" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >ll_file_aio_write</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__find_get_page (7 samples, 0.02%)</title><rect x="65.8" y="245" width="0.2" height="15.0" fill="rgb(254,63,39)" rx="2" ry="2" />
<text text-anchor="" x="68.80" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>grab_cache_page_nowait (19,377 samples, 44.33%)</title><rect x="97.3" y="245" width="523.1" height="15.0" fill="rgb(244,66,9)" rx="2" ry="2" />
<text text-anchor="" x="100.28" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >grab_cache_page_nowait</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_stripe_offset (10 samples, 0.02%)</title><rect x="84.1" y="181" width="0.2" height="15.0" fill="rgb(254,87,54)" rx="2" ry="2" />
<text text-anchor="" x="87.08" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_enqueue (8 samples, 0.02%)</title><rect x="14.6" y="309" width="0.2" height="15.0" fill="rgb(251,200,48)" rx="2" ry="2" />
<text text-anchor="" x="17.59" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_page_cache_add (891 samples, 2.04%)</title><rect x="637.9" y="229" width="24.1" height="15.0" fill="rgb(230,139,25)" rx="2" ry="2" />
<text text-anchor="" x="640.93" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >o..</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>smp_apic_timer_interrupt (36 samples, 0.08%)</title><rect x="1161.4" y="165" width="0.9" height="15.0" fill="rgb(230,112,6)" rx="2" ry="2" />
<text text-anchor="" x="1164.36" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_rdma_remove_commit_uobject (5 samples, 0.01%)</title><rect x="11.1" y="373" width="0.2" height="15.0" fill="rgb(208,95,47)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__hrtimer_run_queues (28 samples, 0.06%)</title><rect x="614.7" y="149" width="0.7" height="15.0" fill="rgb(216,22,12)" rx="2" ry="2" />
<text text-anchor="" x="617.69" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mem_cgroup_update_lru_size (4 samples, 0.01%)</title><rect x="619.2" y="165" width="0.1" height="15.0" fill="rgb(231,182,15)" rx="2" ry="2" />
<text text-anchor="" x="622.22" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_fsync_start (25 samples, 0.06%)</title><rect x="1175.0" y="309" width="0.7" height="15.0" fill="rgb(224,14,26)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_write_iter_init (71 samples, 0.16%)</title><rect x="12.6" y="277" width="1.9" height="15.0" fill="rgb(218,224,15)" rx="2" ry="2" />
<text text-anchor="" x="15.62" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ib_uverbs_write (5 samples, 0.01%)</title><rect x="11.1" y="421" width="0.2" height="15.0" fill="rgb(228,103,14)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_disown0 (76 samples, 0.17%)</title><rect x="673.5" y="197" width="2.1" height="15.0" fill="rgb(218,178,52)" rx="2" ry="2" />
<text text-anchor="" x="676.51" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_lock_irqsave (17,538 samples, 40.12%)</title><rect x="684.0" y="181" width="473.5" height="15.0" fill="rgb(240,5,14)" rx="2" ry="2" />
<text text-anchor="" x="687.04" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >_raw_spin_lock_irqsave</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>task_work_run (9 samples, 0.02%)</title><rect x="1186.7" y="421" width="0.3" height="15.0" fill="rgb(219,38,14)" rx="2" ry="2" />
<text text-anchor="" x="1189.73" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (54 samples, 0.12%)</title><rect x="665.7" y="165" width="1.4" height="15.0" fill="rgb(222,16,30)" rx="2" ry="2" />
<text text-anchor="" x="668.65" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>set_page_dirty (18,367 samples, 42.02%)</title><rect x="676.3" y="213" width="495.9" height="15.0" fill="rgb(222,105,32)" rx="2" ry="2" />
<text text-anchor="" x="679.35" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >set_page_dirty</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>smp_apic_timer_interrupt (4 samples, 0.01%)</title><rect x="23.1" y="245" width="0.1" height="15.0" fill="rgb(218,71,49)" rx="2" ry="2" />
<text text-anchor="" x="26.09" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>new_slab (32 samples, 0.07%)</title><rect x="77.6" y="165" width="0.9" height="15.0" fill="rgb(219,128,17)" rx="2" ry="2" />
<text text-anchor="" x="80.63" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_page_make_ready (212 samples, 0.49%)</title><rect x="1175.9" y="165" width="5.7" height="15.0" fill="rgb(239,108,9)" rx="2" ry="2" />
<text text-anchor="" x="1178.88" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_put (7 samples, 0.02%)</title><rect x="637.6" y="229" width="0.1" height="15.0" fill="rgb(230,142,42)" rx="2" ry="2" />
<text text-anchor="" x="640.55" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>perf (4 samples, 0.01%)</title><rect x="1189.9" y="501" width="0.1" height="15.0" fill="rgb(253,182,47)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="511.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>tick_sched_timer (23 samples, 0.05%)</title><rect x="614.8" y="133" width="0.6" height="15.0" fill="rgb(242,91,22)" rx="2" ry="2" />
<text text-anchor="" x="617.82" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_lock_cancel (6 samples, 0.01%)</title><rect x="1172.7" y="293" width="0.1" height="15.0" fill="rgb(228,65,32)" rx="2" ry="2" />
<text text-anchor="" x="1175.67" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_add (19 samples, 0.04%)</title><rect x="108.6" y="149" width="0.5" height="15.0" fill="rgb(220,99,39)" rx="2" ry="2" />
<text text-anchor="" x="111.56" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (5 samples, 0.01%)</title><rect x="104.2" y="181" width="0.1" height="15.0" fill="rgb(207,208,4)" rx="2" ry="2" />
<text text-anchor="" x="107.19" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_alloc (840 samples, 1.92%)</title><rect x="74.2" y="229" width="22.7" height="15.0" fill="rgb(242,13,1)" rx="2" ry="2" />
<text text-anchor="" x="77.20" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >c..</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_read_lock (8 samples, 0.02%)</title><rect x="621.0" y="229" width="0.2" height="15.0" fill="rgb(217,212,19)" rx="2" ry="2" />
<text text-anchor="" x="624.00" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>____fput (9 samples, 0.02%)</title><rect x="1186.7" y="405" width="0.3" height="15.0" fill="rgb(218,69,14)" rx="2" ry="2" />
<text text-anchor="" x="1189.73" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>pagevec_lru_move_fn (119 samples, 0.27%)</title><rect x="616.5" y="181" width="3.2" height="15.0" fill="rgb(235,1,3)" rx="2" ry="2" />
<text text-anchor="" x="619.47" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>apic_timer_interrupt (38 samples, 0.09%)</title><rect x="1161.3" y="181" width="1.0" height="15.0" fill="rgb(223,136,25)" rx="2" ry="2" />
<text text-anchor="" x="1164.30" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__kprobes_text_start (6 samples, 0.01%)</title><rect x="1188.6" y="261" width="0.2" height="15.0" fill="rgb(205,208,4)" rx="2" ry="2" />
<text text-anchor="" x="1191.62" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_unplug0 (218 samples, 0.50%)</title><rect x="1175.7" y="213" width="5.9" height="15.0" fill="rgb(221,13,3)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ktime_get_seconds (44 samples, 0.10%)</title><rect x="657.2" y="165" width="1.2" height="15.0" fill="rgb(227,55,36)" rx="2" ry="2" />
<text text-anchor="" x="660.18" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_page_state (19 samples, 0.04%)</title><rect x="1160.0" y="165" width="0.5" height="15.0" fill="rgb(248,197,30)" rx="2" ry="2" />
<text text-anchor="" x="1163.03" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>tick_sched_handle (19 samples, 0.04%)</title><rect x="614.9" y="117" width="0.5" height="15.0" fill="rgb(215,212,51)" rx="2" ry="2" />
<text text-anchor="" x="617.93" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__cond_resched (92 samples, 0.21%)</title><rect x="1187.4" y="325" width="2.4" height="15.0" fill="rgb(249,97,31)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_rw_iter_init (73 samples, 0.17%)</title><rect x="12.6" y="325" width="2.0" height="15.0" fill="rgb(217,175,12)" rx="2" ry="2" />
<text text-anchor="" x="15.59" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cfs_cdebug_show.part.1.constprop.38 (13 samples, 0.03%)</title><rect x="643.0" y="213" width="0.4" height="15.0" fill="rgb(209,53,40)" rx="2" ry="2" />
<text text-anchor="" x="646.03" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>page_mapping (12 samples, 0.03%)</title><rect x="1162.4" y="181" width="0.3" height="15.0" fill="rgb(228,126,28)" rx="2" ry="2" />
<text text-anchor="" x="1165.36" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_extent_is_overlapped (5 samples, 0.01%)</title><rect x="643.7" y="213" width="0.1" height="15.0" fill="rgb(232,156,5)" rx="2" ry="2" />
<text text-anchor="" x="646.65" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_extent_make_ready (215 samples, 0.49%)</title><rect x="1175.8" y="197" width="5.8" height="15.0" fill="rgb(207,38,36)" rx="2" ry="2" />
<text text-anchor="" x="1178.80" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_is_vmlocked (10 samples, 0.02%)</title><rect x="632.1" y="213" width="0.3" height="15.0" fill="rgb(253,210,11)" rx="2" ry="2" />
<text text-anchor="" x="635.10" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_start (218 samples, 0.50%)</title><rect x="1175.7" y="261" width="5.9" height="15.0" fill="rgb(222,95,37)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_page_init (509 samples, 1.16%)</title><rect x="79.1" y="213" width="13.7" height="15.0" fill="rgb(230,202,31)" rx="2" ry="2" />
<text text-anchor="" x="82.06" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__x86_indirect_thunk_rax (4 samples, 0.01%)</title><rect x="657.3" y="149" width="0.1" height="15.0" fill="rgb(225,137,1)" rx="2" ry="2" />
<text text-anchor="" x="660.31" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_lock_sub_init (4 samples, 0.01%)</title><rect x="14.9" y="261" width="0.1" height="15.0" fill="rgb(250,7,45)" rx="2" ry="2" />
<text text-anchor="" x="17.94" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__do_softirq (5 samples, 0.01%)</title><rect x="1161.4" y="101" width="0.1" height="15.0" fill="rgb(223,138,4)" rx="2" ry="2" />
<text text-anchor="" x="1164.38" y="111.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_page_init_composite (490 samples, 1.12%)</title><rect x="79.4" y="197" width="13.2" height="15.0" fill="rgb(228,12,19)" rx="2" ry="2" />
<text text-anchor="" x="82.38" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>smp_apic_timer_interrupt (41 samples, 0.09%)</title><rect x="614.5" y="197" width="1.1" height="15.0" fill="rgb(222,138,37)" rx="2" ry="2" />
<text text-anchor="" x="617.50" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ib_uverbs_dereg_mr (5 samples, 0.01%)</title><rect x="11.1" y="405" width="0.2" height="15.0" fill="rgb(250,14,7)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__test_set_page_writeback (22 samples, 0.05%)</title><rect x="1175.1" y="213" width="0.6" height="15.0" fill="rgb(210,126,13)" rx="2" ry="2" />
<text text-anchor="" x="1178.10" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mpirun (121 samples, 0.28%)</title><rect x="1186.6" y="501" width="3.3" height="15.0" fill="rgb(235,108,31)" rx="2" ry="2" />
<text text-anchor="" x="1189.63" y="511.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>filemap_write_and_wait_range (267 samples, 0.61%)</title><rect x="1175.7" y="405" width="7.2" height="15.0" fill="rgb(231,146,21)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (192 samples, 0.44%)</title><rect x="1176.1" y="117" width="5.2" height="15.0" fill="rgb(252,199,19)" rx="2" ry="2" />
<text text-anchor="" x="1179.12" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_attr_get (4 samples, 0.01%)</title><rect x="1172.4" y="277" width="0.1" height="15.0" fill="rgb(239,128,29)" rx="2" ry="2" />
<text text-anchor="" x="1175.40" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__radix_tree_create (174 samples, 0.40%)</title><rect x="609.0" y="181" width="4.7" height="15.0" fill="rgb(240,218,47)" rx="2" ry="2" />
<text text-anchor="" x="612.02" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>balance_dirty_pages_ratelimited (75 samples, 0.17%)</title><rect x="15.6" y="277" width="2.0" height="15.0" fill="rgb(221,28,26)" rx="2" ry="2" />
<text text-anchor="" x="18.62" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>clockevents_program_event (6 samples, 0.01%)</title><rect x="615.4" y="133" width="0.2" height="15.0" fill="rgb(234,97,38)" rx="2" ry="2" />
<text text-anchor="" x="618.44" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (57 samples, 0.13%)</title><rect x="653.8" y="165" width="1.6" height="15.0" fill="rgb(217,130,29)" rx="2" ry="2" />
<text text-anchor="" x="656.83" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>get_partial_node.isra.49 (4 samples, 0.01%)</title><rect x="77.5" y="165" width="0.1" height="15.0" fill="rgb(227,114,39)" rx="2" ry="2" />
<text text-anchor="" x="80.52" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (58 samples, 0.13%)</title><rect x="12.6" y="213" width="1.6" height="15.0" fill="rgb(209,189,29)" rx="2" ry="2" />
<text text-anchor="" x="15.65" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lprocfs_counter_add (52 samples, 0.12%)</title><rect x="92.8" y="213" width="1.4" height="15.0" fill="rgb(226,60,0)" rx="2" ry="2" />
<text text-anchor="" x="95.80" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>system_call_fastpath (292 samples, 0.67%)</title><rect x="1175.0" y="469" width="7.9" height="15.0" fill="rgb(213,79,13)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_page_state (8 samples, 0.02%)</title><rect x="127.4" y="197" width="0.2" height="15.0" fill="rgb(243,34,9)" rx="2" ry="2" />
<text text-anchor="" x="130.38" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lprocfs_stats_unlock (5 samples, 0.01%)</title><rect x="94.4" y="213" width="0.2" height="15.0" fill="rgb(234,86,44)" rx="2" ry="2" />
<text text-anchor="" x="97.42" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_cond_resched (4 samples, 0.01%)</title><rect x="111.1" y="197" width="0.1" height="15.0" fill="rgb(244,60,45)" rx="2" ry="2" />
<text text-anchor="" x="114.10" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>page_waitqueue (8 samples, 0.02%)</title><rect x="674.6" y="165" width="0.2" height="15.0" fill="rgb(205,49,34)" rx="2" ry="2" />
<text text-anchor="" x="677.59" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_start (218 samples, 0.50%)</title><rect x="1175.7" y="293" width="5.9" height="15.0" fill="rgb(221,121,17)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_cache_writeback_range (25 samples, 0.06%)</title><rect x="1175.0" y="293" width="0.7" height="15.0" fill="rgb(232,38,43)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>list_del (9 samples, 0.02%)</title><rect x="109.9" y="165" width="0.2" height="15.0" fill="rgb(209,42,47)" rx="2" ry="2" />
<text text-anchor="" x="112.89" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__add_to_page_cache_locked (18,216 samples, 41.67%)</title><rect x="122.6" y="213" width="491.7" height="15.0" fill="rgb(229,21,23)" rx="2" ry="2" />
<text text-anchor="" x="125.57" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >__add_to_page_cache_locked</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__mem_cgroup_commit_charge (243 samples, 0.56%)</title><rect x="600.0" y="165" width="6.5" height="15.0" fill="rgb(238,120,49)" rx="2" ry="2" />
<text text-anchor="" x="602.97" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_attr_unlock (8 samples, 0.02%)</title><rect x="667.4" y="213" width="0.2" height="15.0" fill="rgb(220,173,26)" rx="2" ry="2" />
<text text-anchor="" x="670.41" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (11 samples, 0.03%)</title><rect x="102.0" y="181" width="0.3" height="15.0" fill="rgb(233,30,15)" rx="2" ry="2" />
<text text-anchor="" x="104.98" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_lock (22 samples, 0.05%)</title><rect x="14.6" y="341" width="0.6" height="15.0" fill="rgb(249,105,29)" rx="2" ry="2" />
<text text-anchor="" x="17.56" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>io_schedule_timeout (25 samples, 0.06%)</title><rect x="1181.9" y="293" width="0.7" height="15.0" fill="rgb(238,74,18)" rx="2" ry="2" />
<text text-anchor="" x="1184.90" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lu_context_key_get (4 samples, 0.01%)</title><rect x="643.4" y="213" width="0.1" height="15.0" fill="rgb(236,222,26)" rx="2" ry="2" />
<text text-anchor="" x="646.44" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>opal_progress (34 samples, 0.08%)</title><rect x="1184.4" y="485" width="0.9" height="15.0" fill="rgb(223,126,19)" rx="2" ry="2" />
<text text-anchor="" x="1187.38" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>do_writepages (218 samples, 0.50%)</title><rect x="1175.7" y="373" width="5.9" height="15.0" fill="rgb(244,225,29)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_lock_irqsave (4 samples, 0.01%)</title><rect x="1161.2" y="149" width="0.1" height="15.0" fill="rgb(247,217,28)" rx="2" ry="2" />
<text text-anchor="" x="1164.17" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (58 samples, 0.13%)</title><rect x="12.6" y="245" width="1.6" height="15.0" fill="rgb(242,129,2)" rx="2" ry="2" />
<text text-anchor="" x="15.65" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_discard (8 samples, 0.02%)</title><rect x="14.3" y="197" width="0.2" height="15.0" fill="rgb(229,118,13)" rx="2" ry="2" />
<text text-anchor="" x="17.27" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>do_execve_common.isra.24 (4 samples, 0.01%)</title><rect x="1189.9" y="437" width="0.1" height="15.0" fill="rgb(246,90,21)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>hrtimer_interrupt (34 samples, 0.08%)</title><rect x="614.7" y="165" width="0.9" height="15.0" fill="rgb(228,69,29)" rx="2" ry="2" />
<text text-anchor="" x="617.69" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_page_init (286 samples, 0.65%)</title><rect x="84.5" y="181" width="7.8" height="15.0" fill="rgb(232,200,35)" rx="2" ry="2" />
<text text-anchor="" x="87.54" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>do_softirq (8 samples, 0.02%)</title><rect x="1161.4" y="133" width="0.2" height="15.0" fill="rgb(223,5,35)" rx="2" ry="2" />
<text text-anchor="" x="1164.36" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (6 samples, 0.01%)</title><rect x="14.3" y="133" width="0.2" height="15.0" fill="rgb(234,51,1)" rx="2" ry="2" />
<text text-anchor="" x="17.32" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>system_call_fastpath (4 samples, 0.01%)</title><rect x="1173.3" y="453" width="0.1" height="15.0" fill="rgb(247,71,34)" rx="2" ry="2" />
<text text-anchor="" x="1176.32" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>perf_pmu_enable (8 samples, 0.02%)</title><rect x="1188.9" y="261" width="0.2" height="15.0" fill="rgb(251,227,32)" rx="2" ry="2" />
<text text-anchor="" x="1191.92" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>update_process_times (19 samples, 0.04%)</title><rect x="1161.8" y="69" width="0.5" height="15.0" fill="rgb(224,212,21)" rx="2" ry="2" />
<text text-anchor="" x="1164.79" y="79.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_queue_async_io (637 samples, 1.46%)</title><rect x="644.6" y="213" width="17.2" height="15.0" fill="rgb(249,201,4)" rx="2" ry="2" />
<text text-anchor="" x="647.60" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_top (10 samples, 0.02%)</title><rect x="673.2" y="197" width="0.3" height="15.0" fill="rgb(238,137,37)" rx="2" ry="2" />
<text text-anchor="" x="676.24" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mlx4_ib_dereg_mr (5 samples, 0.01%)</title><rect x="11.1" y="309" width="0.2" height="15.0" fill="rgb(242,19,21)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_is_owned (9 samples, 0.02%)</title><rect x="622.4" y="245" width="0.2" height="15.0" fill="rgb(242,129,35)" rx="2" ry="2" />
<text text-anchor="" x="625.38" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_rw_init (4 samples, 0.01%)</title><rect x="1172.9" y="357" width="0.1" height="15.0" fill="rgb(224,88,37)" rx="2" ry="2" />
<text text-anchor="" x="1175.94" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>irq_exit (8 samples, 0.02%)</title><rect x="1161.4" y="149" width="0.2" height="15.0" fill="rgb(215,95,0)" rx="2" ry="2" />
<text text-anchor="" x="1164.36" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>page_mapping (14 samples, 0.03%)</title><rect x="676.0" y="213" width="0.3" height="15.0" fill="rgb(235,106,19)" rx="2" ry="2" />
<text text-anchor="" x="678.97" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__osc_unreserve_grant (10 samples, 0.02%)</title><rect x="649.9" y="197" width="0.3" height="15.0" fill="rgb(243,22,10)" rx="2" ry="2" />
<text text-anchor="" x="652.94" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_cond_resched (4 samples, 0.01%)</title><rect x="15.5" y="277" width="0.1" height="15.0" fill="rgb(205,131,0)" rx="2" ry="2" />
<text text-anchor="" x="18.48" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__zone_watermark_ok (5 samples, 0.01%)</title><rect x="109.4" y="165" width="0.2" height="15.0" fill="rgb(223,172,27)" rx="2" ry="2" />
<text text-anchor="" x="112.43" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_wake_cache_waiters (12 samples, 0.03%)</title><rect x="661.3" y="181" width="0.4" height="15.0" fill="rgb(205,77,36)" rx="2" ry="2" />
<text text-anchor="" x="664.34" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (54 samples, 0.12%)</title><rect x="665.7" y="181" width="1.4" height="15.0" fill="rgb(208,81,9)" rx="2" ry="2" />
<text text-anchor="" x="668.65" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>local_apic_timer_interrupt (28 samples, 0.06%)</title><rect x="1161.6" y="149" width="0.7" height="15.0" fill="rgb(243,100,9)" rx="2" ry="2" />
<text text-anchor="" x="1164.57" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_release (9 samples, 0.02%)</title><rect x="1172.7" y="325" width="0.2" height="15.0" fill="rgb(234,178,9)" rx="2" ry="2" />
<text text-anchor="" x="1175.67" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_end (7 samples, 0.02%)</title><rect x="12.4" y="341" width="0.2" height="15.0" fill="rgb(213,102,52)" rx="2" ry="2" />
<text text-anchor="" x="15.40" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_lru_reserve (12 samples, 0.03%)</title><rect x="14.2" y="261" width="0.3" height="15.0" fill="rgb(254,150,46)" rx="2" ry="2" />
<text text-anchor="" x="17.21" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_queue_async_io (4 samples, 0.01%)</title><rect x="671.9" y="229" width="0.1" height="15.0" fill="rgb(248,144,18)" rx="2" ry="2" />
<text text-anchor="" x="674.86" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_cond_resched (92 samples, 0.21%)</title><rect x="1187.4" y="341" width="2.4" height="15.0" fill="rgb(231,103,47)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>system_call_fastpath (5 samples, 0.01%)</title><rect x="11.1" y="469" width="0.2" height="15.0" fill="rgb(218,48,17)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>write_commit_callback (18,524 samples, 42.38%)</title><rect x="672.1" y="229" width="500.1" height="15.0" fill="rgb(205,225,51)" rx="2" ry="2" />
<text text-anchor="" x="675.11" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >write_commit_callback</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_pagevec_put (7 samples, 0.02%)</title><rect x="675.7" y="197" width="0.2" height="15.0" fill="rgb(223,59,34)" rx="2" ry="2" />
<text text-anchor="" x="678.72" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__percpu_counter_add (22 samples, 0.05%)</title><rect x="1160.7" y="165" width="0.6" height="15.0" fill="rgb(229,142,42)" rx="2" ry="2" />
<text text-anchor="" x="1163.68" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_lock_init_composite (5 samples, 0.01%)</title><rect x="14.9" y="277" width="0.1" height="15.0" fill="rgb(220,103,2)" rx="2" ry="2" />
<text text-anchor="" x="17.91" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_write_begin (20,930 samples, 47.88%)</title><rect x="56.2" y="261" width="565.0" height="15.0" fill="rgb(254,152,23)" rx="2" ry="2" />
<text text-anchor="" x="59.22" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >ll_write_begin</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>___slab_alloc (48 samples, 0.11%)</title><rect x="77.2" y="181" width="1.3" height="15.0" fill="rgb(215,58,47)" rx="2" ry="2" />
<text text-anchor="" x="80.25" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>deactivate_task (6 samples, 0.01%)</title><rect x="1182.2" y="229" width="0.2" height="15.0" fill="rgb(237,116,48)" rx="2" ry="2" />
<text text-anchor="" x="1185.23" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__zone_watermark_ok (4 samples, 0.01%)</title><rect x="104.1" y="181" width="0.1" height="15.0" fill="rgb(211,23,48)" rx="2" ry="2" />
<text text-anchor="" x="107.08" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_apic_mem_write (9 samples, 0.02%)</title><rect x="1189.4" y="277" width="0.3" height="15.0" fill="rgb(206,26,34)" rx="2" ry="2" />
<text text-anchor="" x="1192.43" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_unreserve_grant (7 samples, 0.02%)</title><rect x="661.8" y="213" width="0.2" height="15.0" fill="rgb(253,75,50)" rx="2" ry="2" />
<text text-anchor="" x="664.79" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_offset (8 samples, 0.02%)</title><rect x="655.4" y="197" width="0.2" height="15.0" fill="rgb(240,54,51)" rx="2" ry="2" />
<text text-anchor="" x="658.42" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>tick_sched_handle (20 samples, 0.05%)</title><rect x="1161.8" y="85" width="0.5" height="15.0" fill="rgb(232,228,5)" rx="2" ry="2" />
<text text-anchor="" x="1164.76" y="95.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>release_pages (13 samples, 0.03%)</title><rect x="619.3" y="165" width="0.4" height="15.0" fill="rgb(251,58,1)" rx="2" ry="2" />
<text text-anchor="" x="622.33" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_page_make_ready (23 samples, 0.05%)</title><rect x="1175.1" y="229" width="0.6" height="15.0" fill="rgb(205,217,38)" rx="2" ry="2" />
<text text-anchor="" x="1178.10" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_attr_lock (71 samples, 0.16%)</title><rect x="665.5" y="213" width="1.9" height="15.0" fill="rgb(220,31,29)" rx="2" ry="2" />
<text text-anchor="" x="668.49" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__alloc_pages_nodemask (10 samples, 0.02%)</title><rect x="78.2" y="133" width="0.3" height="15.0" fill="rgb(219,104,5)" rx="2" ry="2" />
<text text-anchor="" x="81.19" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_add (12 samples, 0.03%)</title><rect x="106.9" y="165" width="0.3" height="15.0" fill="rgb(226,43,5)" rx="2" ry="2" />
<text text-anchor="" x="109.89" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>put_page (19 samples, 0.04%)</title><rect x="622.8" y="245" width="0.6" height="15.0" fill="rgb(205,113,4)" rx="2" ry="2" />
<text text-anchor="" x="625.84" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>alloc_pages_current (11 samples, 0.03%)</title><rect x="78.2" y="149" width="0.3" height="15.0" fill="rgb(226,201,7)" rx="2" ry="2" />
<text text-anchor="" x="81.19" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock_irq (17,463 samples, 39.95%)</title><rect x="127.7" y="197" width="471.4" height="15.0" fill="rgb(223,66,48)" rx="2" ry="2" />
<text text-anchor="" x="130.70" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >_raw_qspin_lock_irq</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>call_rcu_sched (5 samples, 0.01%)</title><rect x="1186.8" y="373" width="0.1" height="15.0" fill="rgb(236,216,3)" rx="2" ry="2" />
<text text-anchor="" x="1189.76" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mca_btl_vader_component_progress (11 samples, 0.03%)</title><rect x="1183.6" y="485" width="0.3" height="15.0" fill="rgb(219,55,22)" rx="2" ry="2" />
<text text-anchor="" x="1186.63" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_owner_clear.isra.14 (5 samples, 0.01%)</title><rect x="674.1" y="181" width="0.1" height="15.0" fill="rgb(232,51,5)" rx="2" ry="2" />
<text text-anchor="" x="677.05" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>system_call_fastpath (43,009 samples, 98.40%)</title><rect x="12.2" y="453" width="1161.0" height="15.0" fill="rgb(225,31,32)" rx="2" ry="2" />
<text text-anchor="" x="15.16" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >system_call_fastpath</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>page_mapping (16 samples, 0.04%)</title><rect x="1171.7" y="197" width="0.4" height="15.0" fill="rgb(248,70,33)" rx="2" ry="2" />
<text text-anchor="" x="1174.67" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (57 samples, 0.13%)</title><rect x="653.8" y="181" width="1.6" height="15.0" fill="rgb(251,197,11)" rx="2" ry="2" />
<text text-anchor="" x="656.83" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>rdma_remove_commit_uobject (5 samples, 0.01%)</title><rect x="11.1" y="389" width="0.2" height="15.0" fill="rgb(206,178,35)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_page_is_vmlocked (6 samples, 0.01%)</title><rect x="632.2" y="197" width="0.2" height="15.0" fill="rgb(218,214,5)" rx="2" ry="2" />
<text text-anchor="" x="635.21" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_state (4 samples, 0.01%)</title><rect x="127.6" y="197" width="0.1" height="15.0" fill="rgb(214,225,49)" rx="2" ry="2" />
<text text-anchor="" x="130.60" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_request (17 samples, 0.04%)</title><rect x="14.6" y="325" width="0.4" height="15.0" fill="rgb(225,15,15)" rx="2" ry="2" />
<text text-anchor="" x="17.59" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (192 samples, 0.44%)</title><rect x="1176.1" y="101" width="5.2" height="15.0" fill="rgb(222,168,4)" rx="2" ry="2" />
<text text-anchor="" x="1179.12" y="111.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__alloc_pages_nodemask (300 samples, 0.69%)</title><rect x="103.0" y="197" width="8.1" height="15.0" fill="rgb(243,131,22)" rx="2" ry="2" />
<text text-anchor="" x="106.00" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_iter_init (73 samples, 0.17%)</title><rect x="12.6" y="341" width="2.0" height="15.0" fill="rgb(217,229,11)" rx="2" ry="2" />
<text text-anchor="" x="15.59" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__find_get_page (165 samples, 0.38%)</title><rect x="98.1" y="229" width="4.4" height="15.0" fill="rgb(249,184,26)" rx="2" ry="2" />
<text text-anchor="" x="101.09" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_sync_file_range (218 samples, 0.50%)</title><rect x="1175.7" y="341" width="5.9" height="15.0" fill="rgb(248,188,25)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lprocfs_stats_lock (16 samples, 0.04%)</title><rect x="93.8" y="197" width="0.4" height="15.0" fill="rgb(208,77,49)" rx="2" ry="2" />
<text text-anchor="" x="96.77" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>iov_iter_advance (5 samples, 0.01%)</title><rect x="630.0" y="277" width="0.2" height="15.0" fill="rgb(242,191,26)" rx="2" ry="2" />
<text text-anchor="" x="633.05" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_io_write_commit (20,075 samples, 45.93%)</title><rect x="630.7" y="309" width="542.0" height="15.0" fill="rgb(210,219,19)" rx="2" ry="2" />
<text text-anchor="" x="633.72" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >vvp_io_write_commit</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_is_owned (4 samples, 0.01%)</title><rect x="23.3" y="261" width="0.1" height="15.0" fill="rgb(227,190,35)" rx="2" ry="2" />
<text text-anchor="" x="26.28" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__schedule (18 samples, 0.04%)</title><rect x="1182.1" y="245" width="0.5" height="15.0" fill="rgb(227,207,17)" rx="2" ry="2" />
<text text-anchor="" x="1185.09" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_del_entry (7 samples, 0.02%)</title><rect x="109.2" y="133" width="0.2" height="15.0" fill="rgb(225,68,50)" rx="2" ry="2" />
<text text-anchor="" x="112.24" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>[libmlx4-rdmav2.so] (10 samples, 0.02%)</title><rect x="11.8" y="421" width="0.3" height="15.0" fill="rgb(254,57,47)" rx="2" ry="2" />
<text text-anchor="" x="14.81" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_top (10 samples, 0.02%)</title><rect x="667.1" y="197" width="0.3" height="15.0" fill="rgb(224,77,28)" rx="2" ry="2" />
<text text-anchor="" x="670.11" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (54 samples, 0.12%)</title><rect x="665.7" y="197" width="1.4" height="15.0" fill="rgb(217,132,45)" rx="2" ry="2" />
<text text-anchor="" x="668.65" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_tag_set (265 samples, 0.61%)</title><rect x="1164.3" y="181" width="7.2" height="15.0" fill="rgb(251,195,54)" rx="2" ry="2" />
<text text-anchor="" x="1167.30" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>intel_pmu_handle_irq (6 samples, 0.01%)</title><rect x="1189.3" y="277" width="0.1" height="15.0" fill="rgb(210,128,9)" rx="2" ry="2" />
<text text-anchor="" x="1192.27" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>next_extent (5 samples, 0.01%)</title><rect x="655.6" y="197" width="0.2" height="15.0" fill="rgb(242,65,49)" rx="2" ry="2" />
<text text-anchor="" x="658.64" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__rmqueue (70 samples, 0.16%)</title><rect x="107.5" y="165" width="1.9" height="15.0" fill="rgb(233,149,22)" rx="2" ry="2" />
<text text-anchor="" x="110.54" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>system_call_fastpath (4 samples, 0.01%)</title><rect x="1187.0" y="453" width="0.1" height="15.0" fill="rgb(239,78,34)" rx="2" ry="2" />
<text text-anchor="" x="1189.98" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>task_tick_fair (6 samples, 0.01%)</title><rect x="1162.1" y="37" width="0.2" height="15.0" fill="rgb(231,57,30)" rx="2" ry="2" />
<text text-anchor="" x="1165.14" y="47.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_unlock_irqrestore (4 samples, 0.01%)</title><rect x="1171.5" y="197" width="0.1" height="15.0" fill="rgb(216,5,0)" rx="2" ry="2" />
<text text-anchor="" x="1174.53" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_start (25 samples, 0.06%)</title><rect x="1175.0" y="373" width="0.7" height="15.0" fill="rgb(249,33,19)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_stripe_number (16 samples, 0.04%)</title><rect x="83.6" y="181" width="0.5" height="15.0" fill="rgb(217,219,46)" rx="2" ry="2" />
<text text-anchor="" x="86.65" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_write_end (78 samples, 0.18%)</title><rect x="621.2" y="261" width="2.2" height="15.0" fill="rgb(210,208,48)" rx="2" ry="2" />
<text text-anchor="" x="624.25" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>intel_bts_enable_local (4 samples, 0.01%)</title><rect x="1189.2" y="277" width="0.1" height="15.0" fill="rgb(214,222,39)" rx="2" ry="2" />
<text text-anchor="" x="1192.16" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__page_cache_alloc (342 samples, 0.78%)</title><rect x="102.5" y="229" width="9.3" height="15.0" fill="rgb(227,100,33)" rx="2" ry="2" />
<text text-anchor="" x="105.54" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__filemap_fdatawrite_range (218 samples, 0.50%)</title><rect x="1175.7" y="389" width="5.9" height="15.0" fill="rgb(222,116,48)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_attr_update (8 samples, 0.02%)</title><rect x="668.8" y="197" width="0.2" height="15.0" fill="rgb(232,213,20)" rx="2" ry="2" />
<text text-anchor="" x="671.79" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_loop (25 samples, 0.06%)</title><rect x="1175.0" y="389" width="0.7" height="15.0" fill="rgb(237,207,37)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (101 samples, 0.23%)</title><rect x="662.8" y="213" width="2.7" height="15.0" fill="rgb(217,136,47)" rx="2" ry="2" />
<text text-anchor="" x="665.77" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_commit_async (20,043 samples, 45.85%)</title><rect x="631.3" y="277" width="541.1" height="15.0" fill="rgb(207,106,12)" rx="2" ry="2" />
<text text-anchor="" x="634.29" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >lov_io_commit_async</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_unlock (9 samples, 0.02%)</title><rect x="1172.7" y="341" width="0.2" height="15.0" fill="rgb(253,14,9)" rx="2" ry="2" />
<text text-anchor="" x="1175.67" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>memcg_check_events (14 samples, 0.03%)</title><rect x="606.2" y="149" width="0.3" height="15.0" fill="rgb(238,204,2)" rx="2" ry="2" />
<text text-anchor="" x="609.16" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>apic_timer_interrupt (4 samples, 0.01%)</title><rect x="23.1" y="261" width="0.1" height="15.0" fill="rgb(240,226,10)" rx="2" ry="2" />
<text text-anchor="" x="26.09" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (17,339 samples, 39.67%)</title><rect x="131.1" y="181" width="468.0" height="15.0" fill="rgb(221,63,32)" rx="2" ry="2" />
<text text-anchor="" x="134.05" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >queued_spin_lock_slowpath</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_lru_shrink (11 samples, 0.03%)</title><rect x="14.2" y="229" width="0.3" height="15.0" fill="rgb(220,180,54)" rx="2" ry="2" />
<text text-anchor="" x="17.24" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_get (195 samples, 0.45%)</title><rect x="68.9" y="229" width="5.3" height="15.0" fill="rgb(246,45,39)" rx="2" ry="2" />
<text text-anchor="" x="71.93" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__radix_tree_lookup (146 samples, 0.33%)</title><rect x="98.3" y="197" width="4.0" height="15.0" fill="rgb(248,71,25)" rx="2" ry="2" />
<text text-anchor="" x="101.33" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_file_write (43,005 samples, 98.39%)</title><rect x="12.2" y="405" width="1161.0" height="15.0" fill="rgb(218,21,13)" rx="2" ry="2" />
<text text-anchor="" x="15.24" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >ll_file_write</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (21 samples, 0.05%)</title><rect x="81.4" y="181" width="0.6" height="15.0" fill="rgb(244,162,32)" rx="2" ry="2" />
<text text-anchor="" x="84.40" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vfs_write (43,008 samples, 98.39%)</title><rect x="12.2" y="421" width="1161.0" height="15.0" fill="rgb(247,27,54)" rx="2" ry="2" />
<text text-anchor="" x="15.19" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >vfs_write</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_state (5 samples, 0.01%)</title><rect x="1160.5" y="165" width="0.2" height="15.0" fill="rgb(206,18,2)" rx="2" ry="2" />
<text text-anchor="" x="1163.55" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_extent_make_ready (23 samples, 0.05%)</title><rect x="1175.1" y="261" width="0.6" height="15.0" fill="rgb(239,194,34)" rx="2" ry="2" />
<text text-anchor="" x="1178.10" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_page_transfer_get.isra.18 (26 samples, 0.06%)</title><rect x="643.9" y="213" width="0.7" height="15.0" fill="rgb(237,50,4)" rx="2" ry="2" />
<text text-anchor="" x="646.90" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (59 samples, 0.13%)</title><rect x="1162.7" y="181" width="1.6" height="15.0" fill="rgb(219,170,27)" rx="2" ry="2" />
<text text-anchor="" x="1165.71" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>system_call_fastpath (92 samples, 0.21%)</title><rect x="1187.4" y="437" width="2.4" height="15.0" fill="rgb(225,91,0)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_add (16 samples, 0.04%)</title><rect x="618.1" y="149" width="0.4" height="15.0" fill="rgb(222,153,11)" rx="2" ry="2" />
<text text-anchor="" x="621.11" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_top (15 samples, 0.03%)</title><rect x="668.3" y="197" width="0.4" height="15.0" fill="rgb(220,95,16)" rx="2" ry="2" />
<text text-anchor="" x="671.27" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>stub_execve (4 samples, 0.01%)</title><rect x="1189.9" y="469" width="0.1" height="15.0" fill="rgb(219,75,42)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>tick_program_event (6 samples, 0.01%)</title><rect x="615.4" y="149" width="0.2" height="15.0" fill="rgb(226,85,14)" rx="2" ry="2" />
<text text-anchor="" x="618.44" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>scheduler_tick (15 samples, 0.03%)</title><rect x="615.0" y="85" width="0.4" height="15.0" fill="rgb(254,190,34)" rx="2" ry="2" />
<text text-anchor="" x="618.04" y="95.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_attr_update (51 samples, 0.12%)</title><rect x="667.6" y="213" width="1.4" height="15.0" fill="rgb(233,11,33)" rx="2" ry="2" />
<text text-anchor="" x="670.63" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>uverbs_free_mr (5 samples, 0.01%)</title><rect x="11.1" y="341" width="0.2" height="15.0" fill="rgb(226,24,0)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_start (25 samples, 0.06%)</title><rect x="1175.0" y="357" width="0.7" height="15.0" fill="rgb(254,142,53)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_unplug0 (25 samples, 0.06%)</title><rect x="1175.0" y="277" width="0.7" height="15.0" fill="rgb(219,17,6)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_disown (91 samples, 0.21%)</title><rect x="673.2" y="213" width="2.5" height="15.0" fill="rgb(241,25,36)" rx="2" ry="2" />
<text text-anchor="" x="676.24" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mem_cgroup_page_lruvec (12 samples, 0.03%)</title><rect x="618.9" y="165" width="0.3" height="15.0" fill="rgb(251,44,38)" rx="2" ry="2" />
<text text-anchor="" x="621.90" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_state (13 samples, 0.03%)</title><rect x="1160.2" y="149" width="0.3" height="15.0" fill="rgb(231,158,35)" rx="2" ry="2" />
<text text-anchor="" x="1163.20" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>pagevec_lookup_tag (4 samples, 0.01%)</title><rect x="1181.7" y="357" width="0.1" height="15.0" fill="rgb(218,149,2)" rx="2" ry="2" />
<text text-anchor="" x="1184.69" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lprocfs_stats_lock (8 samples, 0.02%)</title><rect x="94.2" y="213" width="0.2" height="15.0" fill="rgb(219,145,39)" rx="2" ry="2" />
<text text-anchor="" x="97.20" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>page_cache_tree_insert (239 samples, 0.55%)</title><rect x="607.6" y="197" width="6.5" height="15.0" fill="rgb(254,26,23)" rx="2" ry="2" />
<text text-anchor="" x="610.61" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_get_trust (20 samples, 0.05%)</title><rect x="644.1" y="197" width="0.5" height="15.0" fill="rgb(224,76,54)" rx="2" ry="2" />
<text text-anchor="" x="647.06" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>kmalloc_slab (7 samples, 0.02%)</title><rect x="78.9" y="213" width="0.2" height="15.0" fill="rgb(237,199,22)" rx="2" ry="2" />
<text text-anchor="" x="81.87" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__fput (8 samples, 0.02%)</title><rect x="1186.7" y="389" width="0.2" height="15.0" fill="rgb(223,88,32)" rx="2" ry="2" />
<text text-anchor="" x="1189.73" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>update_process_times (19 samples, 0.04%)</title><rect x="614.9" y="101" width="0.5" height="15.0" fill="rgb(232,20,16)" rx="2" ry="2" />
<text text-anchor="" x="617.93" y="111.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>stop_one_cpu (92 samples, 0.21%)</title><rect x="1187.4" y="373" width="2.4" height="15.0" fill="rgb(231,63,30)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_commit_async (20,041 samples, 45.85%)</title><rect x="631.3" y="261" width="541.0" height="15.0" fill="rgb(213,105,4)" rx="2" ry="2" />
<text text-anchor="" x="634.29" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >cl_io_commit_async</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_call.isra.7 (7 samples, 0.02%)</title><rect x="12.4" y="309" width="0.2" height="15.0" fill="rgb(224,218,42)" rx="2" ry="2" />
<text text-anchor="" x="15.40" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>get_page_from_freelist (9 samples, 0.02%)</title><rect x="78.2" y="117" width="0.2" height="15.0" fill="rgb(246,155,18)" rx="2" ry="2" />
<text text-anchor="" x="81.19" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_descend (19 samples, 0.04%)</title><rect x="613.2" y="165" width="0.5" height="15.0" fill="rgb(206,179,7)" rx="2" ry="2" />
<text text-anchor="" x="616.20" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_lock_irqsave (194 samples, 0.44%)</title><rect x="1176.1" y="133" width="5.2" height="15.0" fill="rgb(251,216,37)" rx="2" ry="2" />
<text text-anchor="" x="1179.07" y="143.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_maybe_preload (4 samples, 0.01%)</title><rect x="619.8" y="213" width="0.2" height="15.0" fill="rgb(228,12,43)" rx="2" ry="2" />
<text text-anchor="" x="622.84" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_top (6 samples, 0.01%)</title><rect x="667.5" y="197" width="0.1" height="15.0" fill="rgb(213,128,2)" rx="2" ry="2" />
<text text-anchor="" x="670.46" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>poll_device (11 samples, 0.03%)</title><rect x="11.8" y="437" width="0.3" height="15.0" fill="rgb(244,108,41)" rx="2" ry="2" />
<text text-anchor="" x="14.81" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sys_execve (4 samples, 0.01%)</title><rect x="1189.9" y="453" width="0.1" height="15.0" fill="rgb(241,225,51)" rx="2" ry="2" />
<text text-anchor="" x="1192.89" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_page_discard (8 samples, 0.02%)</title><rect x="14.3" y="181" width="0.2" height="15.0" fill="rgb(237,213,53)" rx="2" ry="2" />
<text text-anchor="" x="17.27" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (17 samples, 0.04%)</title><rect x="1175.2" y="165" width="0.4" height="15.0" fill="rgb(210,221,46)" rx="2" ry="2" />
<text text-anchor="" x="1178.15" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__filemap_fdatawait_range (49 samples, 0.11%)</title><rect x="1181.6" y="373" width="1.3" height="15.0" fill="rgb(238,141,11)" rx="2" ry="2" />
<text text-anchor="" x="1184.60" y="383.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_lock_cancel (5 samples, 0.01%)</title><rect x="1172.7" y="277" width="0.1" height="15.0" fill="rgb(208,196,9)" rx="2" ry="2" />
<text text-anchor="" x="1175.67" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (5 samples, 0.01%)</title><rect x="87.7" y="149" width="0.2" height="15.0" fill="rgb(208,107,32)" rx="2" ry="2" />
<text text-anchor="" x="90.75" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_top (5 samples, 0.01%)</title><rect x="622.2" y="245" width="0.2" height="15.0" fill="rgb(205,0,5)" rx="2" ry="2" />
<text text-anchor="" x="625.24" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_lock_cancel (5 samples, 0.01%)</title><rect x="1172.7" y="261" width="0.1" height="15.0" fill="rgb(251,154,6)" rx="2" ry="2" />
<text text-anchor="" x="1175.67" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_init0.isra.15 (4 samples, 0.01%)</title><rect x="1172.9" y="325" width="0.1" height="15.0" fill="rgb(207,49,28)" rx="2" ry="2" />
<text text-anchor="" x="1175.94" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__pagevec_lru_add_fn (70 samples, 0.16%)</title><rect x="616.8" y="165" width="1.9" height="15.0" fill="rgb(244,188,12)" rx="2" ry="2" />
<text text-anchor="" x="619.79" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_fsync (292 samples, 0.67%)</title><rect x="1175.0" y="421" width="7.9" height="15.0" fill="rgb(251,228,48)" rx="2" ry="2" />
<text text-anchor="" x="1178.04" y="431.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>int_signal (9 samples, 0.02%)</title><rect x="1186.7" y="453" width="0.3" height="15.0" fill="rgb(236,72,22)" rx="2" ry="2" />
<text text-anchor="" x="1189.73" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>opal_hwloc1112_hwloc_linux_set_tid_cpubind (93 samples, 0.21%)</title><rect x="1187.3" y="469" width="2.5" height="15.0" fill="rgb(216,126,19)" rx="2" ry="2" />
<text text-anchor="" x="1190.33" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>get_task_policy.part.26 (6 samples, 0.01%)</title><rect x="111.2" y="197" width="0.2" height="15.0" fill="rgb(237,150,37)" rx="2" ry="2" />
<text text-anchor="" x="114.24" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__memset (7 samples, 0.02%)</title><rect x="78.6" y="213" width="0.2" height="15.0" fill="rgb(238,188,36)" rx="2" ry="2" />
<text text-anchor="" x="81.57" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ldlm_lock_decref (4 samples, 0.01%)</title><rect x="1172.7" y="245" width="0.1" height="15.0" fill="rgb(209,189,50)" rx="2" ry="2" />
<text text-anchor="" x="1175.70" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sys_lseek (4 samples, 0.01%)</title><rect x="1173.3" y="437" width="0.1" height="15.0" fill="rgb(233,101,51)" rx="2" ry="2" />
<text text-anchor="" x="1176.32" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>io_schedule (25 samples, 0.06%)</title><rect x="1181.9" y="309" width="0.7" height="15.0" fill="rgb(217,86,10)" rx="2" ry="2" />
<text text-anchor="" x="1184.90" y="319.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>schedule (18 samples, 0.04%)</title><rect x="1182.1" y="261" width="0.5" height="15.0" fill="rgb(251,100,52)" rx="2" ry="2" />
<text text-anchor="" x="1185.09" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sched_setaffinity (92 samples, 0.21%)</title><rect x="1187.4" y="405" width="2.4" height="15.0" fill="rgb(237,30,21)" rx="2" ry="2" />
<text text-anchor="" x="1190.35" y="415.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>lov_io_layout_at (47 samples, 0.11%)</title><rect x="82.4" y="181" width="1.2" height="15.0" fill="rgb(236,119,35)" rx="2" ry="2" />
<text text-anchor="" x="85.38" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (179 samples, 0.41%)</title><rect x="638.2" y="213" width="4.8" height="15.0" fill="rgb(209,109,40)" rx="2" ry="2" />
<text text-anchor="" x="641.17" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>filemap_fdatawait_range (49 samples, 0.11%)</title><rect x="1181.6" y="389" width="1.3" height="15.0" fill="rgb(228,177,26)" rx="2" ry="2" />
<text text-anchor="" x="1184.60" y="399.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__x86_indirect_thunk_rax (5 samples, 0.01%)</title><rect x="68.7" y="229" width="0.1" height="15.0" fill="rgb(226,122,52)" rx="2" ry="2" />
<text text-anchor="" x="71.69" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_page_init (86 samples, 0.20%)</title><rect x="94.6" y="213" width="2.3" height="15.0" fill="rgb(253,200,0)" rx="2" ry="2" />
<text text-anchor="" x="97.55" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>page_waitqueue (14 samples, 0.03%)</title><rect x="675.2" y="149" width="0.4" height="15.0" fill="rgb(250,34,50)" rx="2" ry="2" />
<text text-anchor="" x="678.18" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>native_queued_spin_lock_slowpath (6 samples, 0.01%)</title><rect x="14.3" y="117" width="0.2" height="15.0" fill="rgb(219,32,36)" rx="2" ry="2" />
<text text-anchor="" x="17.32" y="127.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>poll_device (39 samples, 0.09%)</title><rect x="1185.3" y="485" width="1.1" height="15.0" fill="rgb(218,96,27)" rx="2" ry="2" />
<text text-anchor="" x="1188.33" y="495.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_add (9 samples, 0.02%)</title><rect x="649.7" y="197" width="0.2" height="15.0" fill="rgb(207,219,18)" rx="2" ry="2" />
<text text-anchor="" x="652.70" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>llseek (5 samples, 0.01%)</title><rect x="1173.3" y="469" width="0.1" height="15.0" fill="rgb(211,137,51)" rx="2" ry="2" />
<text text-anchor="" x="1176.29" y="479.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_loop (218 samples, 0.50%)</title><rect x="1175.7" y="325" width="5.9" height="15.0" fill="rgb(237,192,48)" rx="2" ry="2" />
<text text-anchor="" x="1178.72" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__call_rcu (5 samples, 0.01%)</title><rect x="1186.8" y="357" width="0.1" height="15.0" fill="rgb(236,176,14)" rx="2" ry="2" />
<text text-anchor="" x="1189.76" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ll_cl_find (31 samples, 0.07%)</title><rect x="620.4" y="245" width="0.8" height="15.0" fill="rgb(208,226,28)" rx="2" ry="2" />
<text text-anchor="" x="623.38" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (5 samples, 0.01%)</title><rect x="87.7" y="165" width="0.2" height="15.0" fill="rgb(244,186,49)" rx="2" ry="2" />
<text text-anchor="" x="90.75" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_start (42,876 samples, 98.09%)</title><rect x="15.2" y="341" width="1157.5" height="15.0" fill="rgb(216,81,22)" rx="2" ry="2" />
<text text-anchor="" x="18.18" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >cl_io_start</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_page_disown (6 samples, 0.01%)</title><rect x="673.0" y="213" width="0.2" height="15.0" fill="rgb(252,143,28)" rx="2" ry="2" />
<text text-anchor="" x="676.02" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>copy_user_enhanced_fast_string (1,158 samples, 2.65%)</title><rect x="23.4" y="261" width="31.3" height="15.0" fill="rgb(223,178,7)" rx="2" ry="2" />
<text text-anchor="" x="26.44" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >co..</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sys_write (43,009 samples, 98.40%)</title><rect x="12.2" y="437" width="1161.0" height="15.0" fill="rgb(254,197,32)" rx="2" ry="2" />
<text text-anchor="" x="15.16" y="447.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >sys_write</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>finish_task_switch (5 samples, 0.01%)</title><rect x="1182.4" y="229" width="0.1" height="15.0" fill="rgb(209,35,11)" rx="2" ry="2" />
<text text-anchor="" x="1185.39" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_page_touch_at (364 samples, 0.83%)</title><rect x="662.0" y="229" width="9.8" height="15.0" fill="rgb(206,47,10)" rx="2" ry="2" />
<text text-anchor="" x="664.98" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>all (43,710 samples, 100%)</title><rect x="10.0" y="517" width="1180.0" height="15.0" fill="rgb(226,125,14)" rx="2" ry="2" />
<text text-anchor="" x="13.00" y="527.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_lookup_slot (5 samples, 0.01%)</title><rect x="620.2" y="229" width="0.2" height="15.0" fill="rgb(230,53,33)" rx="2" ry="2" />
<text text-anchor="" x="623.25" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_del_entry (6 samples, 0.01%)</title><rect x="110.0" y="149" width="0.1" height="15.0" fill="rgb(230,13,53)" rx="2" ry="2" />
<text text-anchor="" x="112.97" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (58 samples, 0.13%)</title><rect x="12.6" y="229" width="1.6" height="15.0" fill="rgb(227,197,26)" rx="2" ry="2" />
<text text-anchor="" x="15.65" y="239.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_io_commit_async (20,044 samples, 45.86%)</title><rect x="631.3" y="293" width="541.1" height="15.0" fill="rgb(248,32,1)" rx="2" ry="2" />
<text text-anchor="" x="634.26" y="303.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  >cl_io_commit_async</text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__perf_event_task_sched_in (37 samples, 0.08%)</title><rect x="1188.2" y="277" width="1.0" height="15.0" fill="rgb(249,107,4)" rx="2" ry="2" />
<text text-anchor="" x="1191.16" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>get_pageblock_flags_group (12 samples, 0.03%)</title><rect x="109.6" y="165" width="0.3" height="15.0" fill="rgb(223,165,38)" rx="2" ry="2" />
<text text-anchor="" x="112.56" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>queued_spin_lock_slowpath (48 samples, 0.11%)</title><rect x="660.0" y="165" width="1.3" height="15.0" fill="rgb(208,207,38)" rx="2" ry="2" />
<text text-anchor="" x="663.04" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>radix_tree_maybe_preload (9 samples, 0.02%)</title><rect x="614.1" y="197" width="0.2" height="15.0" fill="rgb(231,75,19)" rx="2" ry="2" />
<text text-anchor="" x="617.09" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_io_end (5 samples, 0.01%)</title><rect x="12.5" y="261" width="0.1" height="15.0" fill="rgb(222,97,54)" rx="2" ry="2" />
<text text-anchor="" x="15.46" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>ib_dereg_mr (5 samples, 0.01%)</title><rect x="11.1" y="325" width="0.2" height="15.0" fill="rgb(222,191,22)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="335.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__wait_on_bit (40 samples, 0.09%)</title><rect x="1181.8" y="341" width="1.1" height="15.0" fill="rgb(237,199,28)" rx="2" ry="2" />
<text text-anchor="" x="1184.79" y="351.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sys_write (5 samples, 0.01%)</title><rect x="11.1" y="453" width="0.2" height="15.0" fill="rgb(212,136,16)" rx="2" ry="2" />
<text text-anchor="" x="14.13" y="463.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>mem_cgroup_cache_charge (311 samples, 0.71%)</title><rect x="599.1" y="197" width="8.4" height="15.0" fill="rgb(223,227,24)" rx="2" ry="2" />
<text text-anchor="" x="602.14" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>schedule_timeout (18 samples, 0.04%)</title><rect x="1182.1" y="277" width="0.5" height="15.0" fill="rgb(225,128,27)" rx="2" ry="2" />
<text text-anchor="" x="1185.09" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>vvp_page_disown (40 samples, 0.09%)</title><rect x="674.5" y="181" width="1.1" height="15.0" fill="rgb(229,41,8)" rx="2" ry="2" />
<text text-anchor="" x="677.48" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>wait_on_page_bit (42 samples, 0.10%)</title><rect x="1181.8" y="357" width="1.1" height="15.0" fill="rgb(253,145,15)" rx="2" ry="2" />
<text text-anchor="" x="1184.79" y="367.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>cl_object_top (100 samples, 0.23%)</title><rect x="669.0" y="213" width="2.7" height="15.0" fill="rgb(218,34,2)" rx="2" ry="2" />
<text text-anchor="" x="672.00" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>sched_clock (5 samples, 0.01%)</title><rect x="1189.7" y="277" width="0.1" height="15.0" fill="rgb(216,209,54)" rx="2" ry="2" />
<text text-anchor="" x="1192.70" y="287.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__lru_cache_add (147 samples, 0.34%)</title><rect x="615.7" y="197" width="4.0" height="15.0" fill="rgb(232,43,27)" rx="2" ry="2" />
<text text-anchor="" x="618.71" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_extent_release (4 samples, 0.01%)</title><rect x="12.5" y="245" width="0.1" height="15.0" fill="rgb(205,228,42)" rx="2" ry="2" />
<text text-anchor="" x="15.48" y="255.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_unreserve_grant (74 samples, 0.17%)</title><rect x="659.7" y="197" width="2.0" height="15.0" fill="rgb(209,200,38)" rx="2" ry="2" />
<text text-anchor="" x="662.69" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_extent_sanity_check0 (41 samples, 0.09%)</title><rect x="658.6" y="197" width="1.1" height="15.0" fill="rgb(247,196,48)" rx="2" ry="2" />
<text text-anchor="" x="661.58" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>local_apic_timer_interrupt (34 samples, 0.08%)</title><rect x="614.7" y="181" width="0.9" height="15.0" fill="rgb(236,211,42)" rx="2" ry="2" />
<text text-anchor="" x="617.69" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__radix_tree_insert (84 samples, 0.19%)</title><rect x="85.5" y="165" width="2.2" height="15.0" fill="rgb(232,212,17)" rx="2" ry="2" />
<text text-anchor="" x="88.45" y="175.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__inc_zone_state (8 samples, 0.02%)</title><rect x="127.4" y="181" width="0.2" height="15.0" fill="rgb(235,106,40)" rx="2" ry="2" />
<text text-anchor="" x="130.38" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_spin_unlock_irqrestore (13 samples, 0.03%)</title><rect x="1157.5" y="181" width="0.3" height="15.0" fill="rgb(253,179,37)" rx="2" ry="2" />
<text text-anchor="" x="1160.50" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>_raw_qspin_lock (191 samples, 0.44%)</title><rect x="650.2" y="197" width="5.2" height="15.0" fill="rgb(229,185,24)" rx="2" ry="2" />
<text text-anchor="" x="653.21" y="207.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>__list_del_entry (4 samples, 0.01%)</title><rect x="632.0" y="213" width="0.1" height="15.0" fill="rgb(234,215,9)" rx="2" ry="2" />
<text text-anchor="" x="634.96" y="223.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>get_page_from_freelist (235 samples, 0.54%)</title><rect x="104.3" y="181" width="6.4" height="15.0" fill="rgb(218,206,54)" rx="2" ry="2" />
<text text-anchor="" x="107.32" y="191.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>list_del (9 samples, 0.02%)</title><rect x="109.2" y="149" width="0.2" height="15.0" fill="rgb(211,65,35)" rx="2" ry="2" />
<text text-anchor="" x="112.18" y="159.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
<g class="func_g" onmouseover="s(this)" onmouseout="c()" onclick="zoom(this)">
<title>osc_lock_enqueue (7 samples, 0.02%)</title><rect x="14.6" y="261" width="0.2" height="15.0" fill="rgb(248,223,8)" rx="2" ry="2" />
<text text-anchor="" x="17.62" y="271.5" font-size="12" font-family="Verdana" fill="rgb(0,0,0)"  ></text>
</g>
</svg>

--Apple-Mail=_20FAA3B9-CB10-4AA6-8146-ACB6B9D72F27--

--Apple-Mail=_EA59EFD2-F69E-4324-A987-ABC5C770B932
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl0CvIUACgkQcqXauRfM
H+BypA//c1xErye5WL47N3Lt4Yc8bvp8uJt40eOdt0vbq2xdE1uDgvlzC1NrseeX
eflTcMvd9Of0gIspZti8YUhTuG0ha+MF15wGsCwbMbwv6vPWIuUY7Lq7MnELGntD
rryknyg5Em6jFdeopVsucAbEJlLqZ1PYcEBhnYATFC/t3GAOxsNF7zXFQiY/EZ05
GK79t6VCKchgJ5Sa4HaQvMq5mPGWgnAWe8qZmlzKvkCw/9jxT0CEtJ4b5yWXjgnM
ysyE6h5GSOVMc1j7fNMXiyYJA8fb13lseLjyUtNBQsLl1AYYTCRmFOpuue9DxA5R
wa8o5JHBcb+VgpJKAXMRnpfk943DJJA56M//1Q4BaR5s0lVF5YZeGLX0RXIlrSaB
CfDn+dpbZOV9huavCz9SmkYLeAygSii80+b4LDw7cIRlO6sf7w0CMOdwV+Jt7MZI
BBHyq6RQT9YDOFIvhPha+bWLiZ6QXg9wyD10E+Vok5RYHXvNh2bfzCWIJY5+YXlI
AKilr7UXDOPNWnqnFOjIAd3+I/k9XNMa2xiyPSv98IpfBRji0p9Jn7Xwnm0rHIJC
Bfqwuv2Jbs5dA0SzJNA1UY92d03iltU+LM7UjekzoRRiKSTndtpw0+rO0LRVThs6
EYrWZgbQqO/5BouFKXNVPb+VcNfp3ekjh3zaVEp703+opdZlp4A=
=KMtb
-----END PGP SIGNATURE-----

--Apple-Mail=_EA59EFD2-F69E-4324-A987-ABC5C770B932--
